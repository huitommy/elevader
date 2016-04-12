class ElevatorUploader < CarrierWave::Uploader::Base
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
    'default_elevator.png'
  end

  version :large_elevator do
    # returns a 150x150 image
    process resize_to_fill: [150, 150]
  end
  version :medium_elevator do
    # returns a 50x50 image
    process resize_to_fill: [50, 50]
  end
  version :small_elevator do
    # returns a 35x35 image
    process resize_to_fill: [35, 35]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
