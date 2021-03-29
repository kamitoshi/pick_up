# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 管理者を作成する
Admin.create(
  :email => 'kamiya@circrest.com',
  :password => 'admins2021'
)

Shop.create(
  name: "テスト店舗",
  phone_number: "09087654321",
  email: "kamiya@circrest.com",
  postal_code: "4460072",
  prefecture: "愛知県",
  city: "安城市",
  address: "住吉町３−１−１８",
  introduction: "店舗紹介文が入ります",
  password: "test1111",
  url: "https://circrest.com",
  is_active: true
)