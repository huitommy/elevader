class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env == "test"
    storage :file
  else
    storage :fog
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    'http://www.mchail.org/images/mchail/default.png'
  end

  version :large_avatar do
    # returns a 150x150 image
    process resize_to_fill: [350, 350]
  end
  version :medium_avatar do
    # returns a 50x50 image
    process resize_to_fill: [250, 250]
  end
  version :small_avatar do
    # returns a 35x35 image
    process resize_to_fill: [150, 150]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
