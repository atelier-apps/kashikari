class HomeController < ApplicationController

  # デバッグ用画面
  def top
    @payments=Payment.all
    @contracts=Contract.all
    @friends =Friend.all
    friend_names=["山田花子","田中太郎","佐藤一郎","鈴木二郎","木村梅子"]
    if @friends.length==0 then
      for i in 0..4 do
        friend=Friend.new
        friend.name=friend_names[i]
        friend.user_id=1
        friend.save()
      end
      @friends =Friend.all
    end
  end

  # 契約書関連
  def contract
    @contract_id=params[:contract_id]
    @contract =Contract.find(@contract_id)
    @repaymentSum = 0
    @filtered_payments=Payment.where(contract_id: @contract_id)
    if  @filtered_payments.blank?
      @repaymentSum = 0
    else
      @repaymentSum=@filtered_payments.sum(:amount)
    end
  end

  def contract_new

    @user_id=1
    @friend_id=1
    @friend_options=[]
    friends =Friend.all
    friends.each do |friend|
      @friend_options.push([friend.name,friend.id])
    end

    @contract_id=params[:contract_id]
    if !@contract_id.blank? then
      contract=Contract.find(@contract_id)
      @amount=contract.amount
      @note=contract.note
      @friend_id=contract.friend_id
      logger.debug(@friend_id)
      if !contract.deadline.blank? then
        @deadline=contract.deadline.strftime("%Y-%m-%d")
      end
    end
  end


  def contract_complete
    @repaymentSum = 0
    @contract_id=params[:contract_id]
    @passcode=params[:passcode]
    if @contract_id.blank?
      redirect_to(top_path)
    else
      @contract =Contract.find(@contract_id)
    end
  end


  def contract_list
    @contracts =Contract.order(deadline: :asc)
    @contracts =@contracts.where.not(status: "DELETED")


    @note_filter_selected=params[:note_filter_selected]
    if !@note_filter_selected.blank?
      @contracts =@contracts.where(note: @note_filter_selected)
    end

    @friend_filter_selected=params[:friend_filter_selected]
    if !@friend_filter_selected.blank?
      @contracts =@contracts.where(friend_id: @friend_filter_selected)
    end

    @sum=0
    @contracts.each do |contract|
      paymants =Payment.where(contract_id: contract.id)
      sum=paymants.sum(:amount)
      contract.amount=contract.amount-sum
      @sum+=contract.amount
    end

    @users =Friend.all
    @friend_filter=[]
    @users.each do |friend|
      @friend_filter.push([friend.name, friend.id])
    end
  end

  def createContract
    if params[:contract][:id].blank?
      record = Contract.new()
    else
      record = Contract.find(params[:contract][:id])
    end

    record.amount =params[:contract][:amount]
    record.note = params[:contract][:note]
    record.user_id = params[:contract][:user_id]
    record.friend_id = params[:contract][:friend_id]
    record.deadline = params[:contract][:deadline]
    logger.debug("sucsess")
    record.passcode = SecureRandom.hex(4)
    logger.debug(record.passcode)
    record.status = "UNREAD"
    record.save()
    redirect_to(contract_complete_path(contract_id: record.id, passcode: record.passcode))
  end

  def deleteContract

    contract_id=params[:contract_id]
    record = Contract.find(contract_id)
    record.status = "DELETED"
    record.save()
    redirect_to(contract_list_path)
  end

  #契約の控えを相手に送る
  def sendAgreement
    contract_id = params[:contract_id]
    passcode = params[:passcode]
    lineSend="https://social-plugins.line.me/lineit/share?url="
    agreementPage="https://app-kashikari-develop.herokuapp.com/contract_agree?cp=" + contract_id.to_s + "-" + passcode.to_s
    logger.debug(agreementPage)
    logger.debug(lineSend + agreementPage)
    redirect_to lineSend + agreementPage
  end

  # 契約控え
  def contract_agree
    cp=params[:cp].split("-")
    @contract_id=cp[0]
    @passcode=cp[1]
    @contract =Contract.find(@contract_id)
    if @contract.passcode == @passcode
      @repaymentSum = 0
      @filtered_payments=Payment.where(contract_id: @contract_id)
      if  @filtered_payments.blank?
        @repaymentSum = 0
      else
        @repaymentSum=@filtered_payments.sum(:amount)
      end
    else
      redirect_to(top_path)
    end
  end

  # 契約合意ボタン
  def agreementButton
    contract = Contract.find(params[:contract_id])
    contract.status = "ACCEPTED"
    contract.save
    redirect_to(contract_agree_path(contract_id: params[:contract_id]))
  end

  # 返済関連

  def createPayment

    record = Payment.new()
    record.amount =params[:payment][:amount]
    record.contract_id = params[:payment][:contract_id]

    # ここで返済額(Contract.amout)が0以下になる場合は、保存させない

    contract =Contract.find(record.contract_id)
    repaymentSum = 0
    filtered_payments=Payment.where(contract_id: record.contract_id)
    repaymentSum=filtered_payments.sum(:amount)
    if  contract.amount- (repaymentSum + record.amount) >= 0 then
      record.save()
      #返済完了判定
      contract =Contract.find(record.contract_id)
      balance=contract.amount
      payments=Payment.where(contract_id: record.contract_id)
      payments.each do |payment|
        balance-=payment.amount
      end
      logger.debug(balance)
      if balance<=0 then
        contract.status="PAID"
        contract.save()
      end
    redirect_to(contract_list_path)
    else
      #Windows用のポップアップっぽい。。。
      flash[:notice] = "金額が超過しています。"

      redirect_to(contract_path(contract_id: record.contract_id))
    end



  end


  # 友達関連
  def createFriend
    record = Friend.new()
    record.name= params[:name]
    record.user_id= params[:user_id]
    record.save()
    friends=Friend.where(user_id: record.user_id)
    html=""
    friends.each do |friend|
      html+="<option value='"+friend.id.to_s+"'>"+friend.name+"</option>"
    end
    render json: { friend_id: record.id, friends: friends, html: html}
  end


end
