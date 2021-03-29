class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :kana_last_name, presence: true
  validates :kana_first_name, presence: true
  validates :phone_number, presence: true

  has_many :orders

  has_many :cart_items

  # omniauthのコールバック時に呼ばれるメソッド
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  # フルネームで表示する
  def full_name
    self.last_name + " " + self.first_name
  end

  # カナのフルネームを表示
  def kana_full_name
    self.kana_last_name + " " + self.kana_first_name
  end

  # 該当の商品がすでにカートに入っているかを判別
  def cart_already_include(menu)
    cart_items = self.cart_items
    if cart_items.count != 0
      cart_items.each do |item|
        if item.menu_id == menu.id
          return true
        else
          next
        end
      end
      return false
    else
      return false
    end
  end

  # カートに入っている商品の中で一番完成予定が長いものを出力
  def max_estimated_time
    result = 0
    self.cart_items.each do |item|
      if item.menu.estimated_time > result
        result = item.menu.estimated_time
      end
    end
    return result
  end

  # カートに入っている商品の合計金額を算出
  def cart_items_total_price
    result = 0
    self.cart_items.each do |item|
      result += item.menu.price * item.amount
    end
    return result
  end

end
