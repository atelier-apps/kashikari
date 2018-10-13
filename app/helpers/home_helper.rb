module HomeHelper
  def getEventType
    return ["立て替え","飲み会","旅行"]
  end
end

module HomeHelper
  def getContractStatus
    statusName=Status.find(@contract.status_id)
    return statusName.japanese
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
