module ApplicationHelper
  def parse_time(time)
    time.strftime("%Y/%m/%d %H:%M")
  end
  def parse_date(date)
    date.strftime("%Y/%m/%d")
  end
  def parse_amount(amount)
    return amount.to_s(:delimited)+"円"
  end
  def parse_status(status)
    if status==get_status_id_by_key("PAID") then
      return image_tag("icon_paid.png", name: status)
    end
      return image_tag("icon_unpaid.png", name: status)
  end
end
