class HomeController < ApplicationController
  #認証
  before_action :authenticate_user!, :except=>[:top, :contract_agree]

  # デバッグ用画面
  def top
    @payments=Payment.all
    @contracts=Contract.all
    @friends =Friend.all
    @users =User.all

  end

  # 契約書関連
  def contract
    @contract_id=params[:contract_id]
    @contract =Contract.find(@contract_id)
    if @contract.user_id != current_user.id then
      redirect_to(top_path)
    end

    if @contract.status_id==view_context.get_status_id_by_key("DELETED") then
      redirect_to(contract_list_path)
    end
    @repaymentSum = 0
    @filtered_payments=Payment.where(contract_id: @contract_id)
    if @filtered_payments.blank?
      @repaymentSum = 0
    else
      @repaymentSum=@filtered_payments.sum(:amount)
    end
  end

  def contract_new

    @user_id=current_user.id

    @friend_options=[]
    my_friends = Friend.where(created_by: current_user.id)
    friends = my_friends.order(contract_times: "DESC")
    firstFriend=friends.first
    @friend_id=firstFriend.id
    friends.each do |friend|
      @friend_options.push([friend.name,friend.id])
    end

    require "date"
    date = Date.today
    @deadline=date +7

    #@contract_id=params[:contract_id]
    #if !@contract_id.blank? then
    #  contract=Contract.find(@contract_id)
    #  @amount=contract.amount
    #  @note=contract.note
    #  @friend_id=contract.friend_id
    #  logger.debug(@friend_id)
    #  if !contract.deadline.blank? then
    #    @deadline=contract.deadline.strftime("%Y-%m-%d")
    #  end
    #end
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

    my_contracts=Contract.where(user_id: current_user.id)
    my_contracts =my_contracts.where.not(status_id: view_context.get_status_id_by_key("DELETED"))
    @contracts =my_contracts.order(deadline: :asc)

    @status_filter_selected=params[:status_filter_selected]
    if !@status_filter_selected.blank?
      @contracts =@contracts.where(status_id: @status_filter_selected)
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

    my_friends = Friend.where(created_by: current_user.id)
    @friends = my_friends.order(contract_times: "DESC")
    @friend_filter=[]
    @friends.each do |friend|
      @friend_filter.push([friend.name, friend.id])
    end

    @statuses = Status.where(key: ["UNPAID", "PAID"])
    @status_filter=[]
    @statuses.each do |status|
      @status_filter.push([status.japanese, status.id])
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
    record.passcode = SecureRandom.hex(4)
    record.status_id = view_context.get_status_id_by_key("UNPAID")
    record.save()

    friend=Friend.find(record.friend_id)
    friend.contract_times+=1
    friend.save()
    redirect_to(contract_complete_path(contract_id: record.id, passcode: record.passcode))
  end

  def deleteContract
    contract_id=params[:contract_id]
    record = Contract.find(contract_id)
    record.status_id = view_context.get_status_id_by_key("DELETED")
    record.save()
    return true
  end

  #契約の控えを相手に送る
  def sendAgreement
    contract_id = params[:contract_id]
    passcode = params[:passcode]
    lineSend="https://social-plugins.line.me/lineit/share?url="
    agreementPage="https://app-kashikari-develop.herokuapp.com/contract_agree?cp=" + contract_id.to_s + "-" + passcode.to_s#passを本番環境ように切りかえる必要アリ
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


  # 返済関連
  def createPayment

    def checkDifference
      contract =Contract.find(params[:payment][:contract_id])
      payments=Payment.where(contract_id: params[:payment][:contract_id])
      amount=contract.amount
      current_payment = params[:payment][:amount].to_i
      payment_sum=payments.sum(:amount).to_i
      difference = amount - payment_sum - current_payment
      return difference
    end

    contract =Contract.find(params[:payment][:contract_id])

    if contract.status_id==view_context.get_status_id_by_key("DELETED") then
      return redirect_to(contract_list_path)
    end

    difference=checkDifference

    if difference<0 then
      return redirect_to (contract_path(contract_id: params[:payment][:contract_id]))
    elsif difference==0 then
      contract.status_id = view_context.get_status_id_by_key("PAID")
      contract.save()
    end

    record = Payment.new()
    record.amount =params[:payment][:amount]
    record.contract_id = params[:payment][:contract_id]
    record.save()

    return redirect_back(fallback_location: contract_list_path)
  end

  # 友達関連
  def createFriend

    same_friends=Friend.where(name: params[:name])
    if same_friends.length>0 then
      return false
    end

    record = Friend.new()
    record.name= params[:name]
    record.created_by=current_user.id
    record.contract_times=0
    record.save()
    friends=Friend.where(created_by: record.created_by)
    html=""
    friends.each do |friend|
      html+="<option value='"+friend.id.to_s+"'>"+friend.name+"</option>"
    end
    render json: { friend_id: record.id, friends: friends, html: html}
  end

  def editFriend
    record = Friend.find(params[:frined_id])
    record.name= params[:name]
    record.save()
    render json: { friend_id: record.id}
  end

  def friend_list
    my_friends =Friend.where(created_by: current_user.id)
    @friends =my_friends.order(updated_at: :desc)
  end

  def goBackList
    return redirect_to(contract_list_path)
  end



end
