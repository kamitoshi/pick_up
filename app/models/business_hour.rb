class BusinessHour < ApplicationRecord
  belongs_to :shop

  enum job_time: {
    終日:1,モーニング:2,ランチ:3,ディナー:4
  }

  validates :job_time, presence: true
  validates :opening, presence: true
  validates :closing, presence: true
  validates :last_order, presence: true
end
