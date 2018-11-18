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
  def parse_status(status_id)
    status=Status.find(status_id)
    return content_tag("div",status.icon_japanese,class: ["status-icon", "status-"+status.key])
  end
end
