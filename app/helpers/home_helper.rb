module HomeHelper
  def getEventType
    return ["立て替え","飲み会","旅行"]
  end

  def getContractStatus
    statusName=Status.find(@contract.status_id)
    return statusName.japanese
  end

  def getFriendName
    friendName=Friend.find(@contract.friend_id)
    return friendName.name
  end

  def getContractName
    contractName=User.find(@contract.user_id)
    return contractName.name
  end

  def get_status_id_by_key(key)
    return Status.where(key: key)[0].id
  end
end
