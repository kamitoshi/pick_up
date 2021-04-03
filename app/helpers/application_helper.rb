module ApplicationHelper
  def price(price)
    price.to_s(:delimited)
  end
end
