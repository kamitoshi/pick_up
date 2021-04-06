module ApplicationHelper
  def price(price)
    price.to_s(:delimited)
  end

  def introduction(text)
    safe_join(text.split("\n"),tag(:br))
  end
end
