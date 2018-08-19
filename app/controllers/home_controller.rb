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
  def contract
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
  def contract_list
    @contracts =Contract.all
    @users =User.all
    @payments =Payment.all
  end
  def friend_list
    @users =User.all
    @friends =Friend.all
  end
  def friend_new
    @friends =Friend.all
  end
  def addFriend
    my_id=1
    friend_account=params[:friend][:followee]
    if !User.exists?(account: friend_account) then
      redirect_to friend_new_path, notice: "存在しません"
    else
      friend=User.find_by(account: friend_account)
      friend_id=friend.id
      if my_id==friend_id
        redirect_to friend_new_path, notice: "自分"
      elsif Friend.exists?(follower: my_id, followee: friend_id)
        redirect_back(fallback_location: friend_new_path, notice: "すでに")
      else
        record = Friend.new()
        record.follower =my_id
        record.followee =friend_id
        record.save()
        redirect_to(friend_list_path)
      end
    end

  end
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
  def createContract
    record = Contract.new()
    record.amount =params[:contract][:amount]
    record.note = params[:contract][:note]
    record.credit = params[:contract][:credit]
    record.debit = params[:contract][:debit]
    record.deadline = params[:contract][:deadline]
    record.status = "UNREAD"
    record.save()
    redirect_to(contract_list_path)
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
end
