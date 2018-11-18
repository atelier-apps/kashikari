module HomeHelper
  def getContractStatus
    statusName=Status.find(@contract.status_id)
    return statusName.japanese
  end

  def getFriendName(friend_id)
    return Friend.find(friend_id).name
  end

  def getUserName(user_id)
    return User.find(user_id).name
  end

  def get_status_id_by_key(key)
    return Status.where(key: key)[0].id
  end
end
