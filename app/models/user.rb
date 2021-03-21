class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :kana_last_name, presence: true
  validates :kana_first_name, presence: true
  validates :phone_number, presence: true

  has_many :orders

  has_many :cart_items

  class User < ApplicationRecord
    devise :omniauthable, omniauth_providers: %i[facebook twitter google_oauth2]
    # omniauthのコールバック時に呼ばれるメソッド
    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
      end
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

end
