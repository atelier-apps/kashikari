class HomeController < ApplicationController

  # デバッグ用画面
  def top
    @payments=Payment.all
    @contracts=Contract.all
    @users =User.all
    user_names=["山田花子","田中太郎","佐藤一郎","鈴木二郎","木村梅子"]
    if @users.length==0 then
      for i in 0..4 do
        user=User.new
        user.name=user_names[i]
        user.account=i
        user.save()
      end
      @users =User.all
    end
  end

  # 契約書関連
  def contract
    @contract_id=params[:contract_id]
    if @contract_id.blank?
      redirect_to(top_path)
    else
      @contract =Contract.find(@contract_id)
      @filtered_payments=Payment.where(contract_id: @contract_id)
      @paid_amount=0
      @filtered_payments.each do |filtered_payment|
        @paid_amount+=filtered_payment.amount
      end
    end
  end

  def contract_new
    friend_id=params[:friend_id]
    if friend_id.blank? then
      friend_id=""
    end
    @debit_id=friend_id
    @credit_id=1
    @friend_options=[]
    users =User.all
    users.each do |user|
      @friend_options.push([user.name,user.id])
    end
  end


  def contract_complete
    @contract_id=params[:contract_id]
    if @contract_id.blank?
      redirect_to(top_path)
    else
      @contract =Contract.find(@contract_id)
    end
  end


  def contract_list
    @contracts =Contract.order(deadline: :desc)

    @note_filter_selected=params[:note_filter_selected]
    if !@note_filter_selected.blank?
      @contracts =@contracts.where(note: @note_filter_selected)
    end

    @friend_filter_selected=params[:friend_filter_selected]
    if !@friend_filter_selected.blank?
      @contracts =@contracts.where(friend_id: @friend_filter_selected)
    end

    @sum=@contracts.sum(:amount)
    @users =User.all
    @friend_filter=[]
    @users.each do |friend|
      @friend_filter.push([friend.name, friend.id])
    end
  end

  def createContract
    record = Contract.new()
    record.amount =params[:contract][:amount]
    record.note = params[:contract][:note]
    record.user_id = params[:contract][:credit]
    record.friend_id = params[:contract][:debit]
    record.deadline = params[:contract][:deadline]
    record.status = "UNREAD"
    record.save()
    redirect_to(contract_complete_path(contract_id: record.id))
  end


  # 返済関連

  def createPayment
    record = Payment.new()
    record.amount =params[:payment][:amount]
    record.contract_id = params[:payment][:contract_id]
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
  end

end
