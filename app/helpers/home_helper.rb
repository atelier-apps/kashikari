module HomeHelper
  def getEventType
    return ["立て替え","飲み会","旅行"]
  end
end

module HomeHelper
  def getStatusType
    return ["UNREAD","PAID"]
  end
end

module HomeHelper
  def getFriendName
    friendName=Friend.find(@contract.friend_id)
    return friendName.name
  end
end

module HomeHelper
  def getContractName
    contractName=User.find(@contract.user_id)
    return contractName.name
  end
end

module HomeHelper
  def getContractStatus
    if @contract.status == "UNREAD"
      statusName = "未決済"
    elsif @contract.status == "PAID"
      statusName = "決済済み"
    else
      statusName = "削除済み"
    end
      return statusName
  end
end
