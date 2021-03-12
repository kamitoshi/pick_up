module Admins::MenusHelper
  def menu_sumnail_image(menu)
    if menu.menu_images.present?
      image_tag "noimage.png", :size => "50x50"
    else
      image_tag menu.menu_images[0].thumb50.to_s
    end
  end
end
