task :notice_task => :environment do

    def make_message(contracts)
      deadline_contents=[]
      amount_contents=[]
      contracts.each do |contract|
        deadline_date="--/--"
        if !contract.deadline.blank? then
          deadline_date=contract.deadline.strftime("%m/%d")
        end

        deadline_contents.push({
          "type": "text",
          "text": ""+deadline_date+" "+Friend.find(contract.friend_id).name
        })

        repaymentSum = 0
        filtered_payments=Payment.where(contract_id: contract.id)
        if !filtered_payments.blank?
          repaymentSum=filtered_payments.sum(:amount)
        end
        amount_contents.push({
          "type": "text",
          "align": "end",
          "text": (contract.amount-repaymentSum).to_s+"円"
        })
      end

      deadline={
        "type": "box",
        "layout": "vertical",
        "flex": 2,
        "spacing": "sm",
        "contents": deadline_contents
      }
      amount={
        "type": "box",
        "layout": "vertical",
        "flex": 1,
        "spacing": "sm",
        "contents": amount_contents
      }

      contents=[]
      contents.push(deadline)
      contents.push(amount)


      message = {
        "type": "flex",
        "altText": "未回収の請求があります。",
        "contents": {
          "type": "bubble",
          "styles": {
            "body": {
              "backgroundColor": "#f0f0f0"
            }
          },
          "body": {
            "type": "box",
            "layout": "vertical",
            "spacing": "md",
            "contents": [
              {
                "type": "box",
                "layout": "vertical",
                "spacing": "sm",
                "contents": [
                  {
                    "type": "text",
                    "text": "未回収の請求",
                    "size": "lg",
                    "weight": "bold"
                  },
                  {
                    "type": "text",
                    "text": "回収期限の過ぎている請求ノートが"+contracts.length.to_s+"件あります",
                    "size": "sm"
                  }
                ]
              },
              {
                "type": "box",
                "layout": "horizontal",
                "contents": contents
              },
              {
                "type": "text",
                "align": "end",
                "size": "xxs",
                "color": "#888888",
                "text": "＊詳細はアプリ内で確認できます"
              }
            ]
          }
        }
      }
      return message
    end


    require "date"
    date = Date.today

    if date.day==25 then
      users=User.all
      users.each do |user|
        my_contracts=Contract.where(user_id: user.id)
        my_contracts=my_contracts.where("deadline < ? or deadline is NULL", date)
        status=Status.where(key: "UNPAID")[0]
        contracts=my_contracts.where(status_id: status.id)

        if contracts.length>0 then
          message=make_message(contracts)
          require 'line/bot'
          client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV['LINE_SECRET']
            config.channel_token = ENV['LINE_TOKEN']
          }
          response = client.push_message(user.uid, message)
        end
      end
    end

end
