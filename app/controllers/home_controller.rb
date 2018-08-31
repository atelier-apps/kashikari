class HomeController < ApplicationController

  # デバッグ用画面
  def top
    @payments=Payment.all
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

  # 契約書関連
  def contract
    @contract_id=params[:contract_id]
    if @contract_id.blank?
      redirect_to(top_path)
    else
      @contract =Contract.find(@contract_id)
      @filtered_payments=Payment.where(contract_id: @contract_id)
    end
  end

  def contract_new
    @event_options=["立て替え","飲み会","旅行"]

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
    redirect_to(contract_complete_path(contract_id: record.id))
  end

  # 返済関連

  def createPayment
    record = Payment.new()
    record.amount =params[:payment][:amount]
    record.contract_id = params[:payment][:contract_id]
    record.save()
    redirect_to(contract_list_path)
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
