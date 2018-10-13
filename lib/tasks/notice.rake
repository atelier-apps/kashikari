task :notice_task => :environment do

    def make_message(id)
      message = {
        "type": "flex",
        "altText": "未回収の契約があります。",
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
                    "text": "未回収の契約"+id.to_s,
                    "size": "lg",
                    "weight": "bold"
                  },
                  {
                    "type": "text",
                    "text": "以下3件の未回収金を取り立てよう！",
                    "size": "sm"
                  }
                ]
              },
              {
                "type": "box",
                "layout": "horizontal",
                "contents": [
                  {
                    "type": "box",
                    "layout": "vertical",
                    "flex": 2,
                    "spacing": "sm",
                    "contents": [
                      {
                        "type": "text",
                        "text": "[09/10] 小保方晴子"
                      },
                      {
                        "type": "text",
                        "text": "[09/10] 田中花子"
                      },
                      {
                        "type": "text",
                        "text": "[09/10] 五十嵐二郎"
                      }
                    ]
                  },
                  {
                    "type": "box",
                    "layout": "vertical",
                    "flex": 1,
                    "spacing": "sm",
                    "contents": [
                      {
                        "type": "text",
                        "align": "end",
                        "text": "5,000円"
                      },
                      {
                        "type": "text",
                        "align": "end",
                        "text": "400円"
                      },
                      {
                        "type": "text",
                        "align": "end",
                        "text": "2,400円"
                      }
                    ]
                  }
                ]
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


    users=User.all

    users.each do |user|
      make_message(user.id)
      require 'line/bot'
      client = Line::Bot::Client.new { |config|
        config.channel_secret = ENV['LINE_SECRET']
        config.channel_token = ENV['LINE_TOKEN']
      }
      response = client.push_message(user.uid, message)
    end
end
