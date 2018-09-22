module ApplicationHelper
  def parse_time(time)
    time.strftime("%Y-%m-%d　%H:%M　")
  end
  def parse_amount(amount)
    return amount.to_s+"円"
  end
  def parse_status(status)
    if status=="PAID" then
      return link_to(image_tag("icon_paid.png"),top_path)
    end
      return link_to(image_tag("icon_unpaid.png"),top_path)
  end
end
