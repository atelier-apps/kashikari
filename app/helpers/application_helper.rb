module ApplicationHelper
  def parse_time(time)
    time.strftime("%Y-%m-%d　%H:%M　")
  end
  def parse_amount(amount)
    return amount.to_s+"円"
  end
  def get_status_id_by_key(key)
    return Status.where(key: key)[0].id
  end
  def parse_status(status)
    if status=="PAID" then
      return image_tag("icon_paid.png", name: status)
    end
      return image_tag("icon_unpaid.png", name: status)
  end
end
