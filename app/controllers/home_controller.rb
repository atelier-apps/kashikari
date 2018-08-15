class HomeController < ApplicationController
  def top
    @contracts =Contract.all
    @payments =Payment.all
  end
  def contract
  end
  def contract_new
  end
  def contract_list
  end
  def friend_list
  end
  def friend_new
  end
  def payback_new
  end
  def payback_complete
  end
  def createPayment
    record = Payment.new()
    record.amount =params[:payment][:amount]
    record.contractId = params[:payment][:contractId]
    record.note = params[:payment][:note]
    record.save()
    redirect_to '/payback_complete'
  end
end
