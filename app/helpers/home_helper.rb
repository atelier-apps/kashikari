module HomeHelper
  def getEventType
    return ["立て替え","飲み会","旅行"]
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
    if @contract.status == 1
      statusName = "未決済"
    elsif @contract.status == 2
      statusName = "決済済"
    else
      statusName = "削除済み"
    end
      return statusName
  end
end
