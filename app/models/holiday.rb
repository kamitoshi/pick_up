class Holiday < ApplicationRecord
  belongs_to :shop

  validates :weekday, presence: true

  enum weekday: {
    日曜日:0,月曜日:1,火曜日:2,水曜日:3,木曜日:4,金曜日:5,土曜日:6
  }
end
