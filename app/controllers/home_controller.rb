class HomeController < ApplicationController
  def top
    @users =User.all
    if @users.length==0 then
      for i in 1..5 do
        user=User.new
        user.name="Test User"+i.to_s
        user.account="a"+i.to_s
        user.save()
      end
      @users =User.all
    end
  end


  #契約関連

  def contract
  end

  def contract_new
    friend_id=params[:friend_id]
    if friend_id.blank? then
      friend_id=""
    end
    @debit_id=1
    @credit_id=friend_id
    @friend_options=[]
    users =User.all
    users.each do |user|
      @friend_options.push([user.name,user.id])
    end
  end

  def contract_list
    @contracts =Contract.all
    @users =User.all
    @payments =Payment.all
  end

  def createContract
    record = Contract.new()
    record.amount =params[:contract][:amount]
    record.note = params[:contract][:note]
    record.credit = params[:contract][:credit]
    record.debit = params[:contract][:debit]
    record.deadline = params[:contract][:deadline]
    record.status = "UNREAD"
    record.save()
    redirect_to contract_list_path
  end


  # 友達関連

  def friend
    @user_id=params[:user_id]
    if @user_id.blank?
      redirect_to(top_path)
    else
      @friend =Friend.find_by(followee: @user_id)
      @users =User.all
      @user =@users.find(@user_id)
      @contracts_credit=Contract.where(credit: 1, debit:@user_id)
      @contracts_debit=Contract.where(credit: @user_id, debit: 1)
      @balance=balance(@contracts_credit, @contracts_debit)

    end
  end

  def friend_new
    @friends =Friend.all
  end

  def friend_list
    @users =User.all
    @friends =Friend.all
  end

  def addFriend
    my_id=1
    friend_account=params[:friend][:followee]
    if !User.exists?(account: friend_account) then
      redirect_back(fallback_location: top_path)
    else
      friend=User.find_by(account: friend_account)
      friend_id=friend.id
      if my_id==friend_id
        redirect_back(fallback_location: top_path)
      elsif Friend.exists?(follower: my_id, followee: friend_id)
        redirect_back(fallback_location: top_path)
      else
        record = Friend.new()
        record.follower =my_id
        record.followee =friend_id
        record.save()
        redirect_to friend_list_path
      end
    end
  end


  #支払い関連

  def payback_new
    @payments =Payment.all
    @contract_id=params[:contract_id]
    if @contract_id.blank?
      redirect_to(top_path)
    else
      @contract =Contract.find(@contract_id)
      if @contract.status=="UNREAD" then
        @contract.status = "READ"
        @contract.save()
      end
    end
  end

  def payback_agree
    payment_id=params[:payment_id]
    if payment_id.blank?
      redirect_to(contract_list_path)
    else
      @payment =Payment.find(payment_id)
      if @payment.status=="UNREAD" then
        @payment.status = "READ"
        @payment.save()
      end
    end
  end

  def payback_agree_accepted
  end

  def payback_agree_rejected
  end

  def createPayment
    record = Payment.new()
    record.amount =params[:payment][:amount]
    record.contract_id = params[:payment][:contract_id]
    record.note = params[:payment][:note]
    record.status = "UNREAD"
    record.save()
    redirect_to(contract_list_path)
  end

  def agreePayment
    id=params[:payment_id]
    @payment=Payment.find(id)
    @payment.status="ACCEPTED"
    @payment.save()
    redirect_back(fallback_location: top_path)
  end

  def disagreePayment
    id=params[:payment_id]
    @payment=Payment.find(id)
    @payment.status="REJECTED"
    @payment.save()
    redirect_back(fallback_location: top_path)
  end


  #清算関連

  def balance (contracts_credit, contracts_debit)
    balance=0
    payments=Payment.all

    contracts_credit.each do |contract|
      if contract.status!="PAID" then
        balance-=contract.amount
        related_payments=payments.where(contract_id: contract.id)
        related_payments.each do |related_payment|
          balance+=related_payment.amount
        end
      end
    end

    contracts_debit.each do |contract|
      if contract.status!="PAID" then
        balance+=contract.amount
        related_payments=payments.where(contract_id: contract.id)
        related_payments.each do |related_payment|
          balance-=related_payment.amount
        end
      end
    end

    return balance

  end

end
