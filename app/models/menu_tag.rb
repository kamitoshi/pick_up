class MenuTag < ApplicationRecord
  belongs_to :menu

  validates :content, presence: true
end
