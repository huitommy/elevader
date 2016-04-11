# encoding: utf-8

class ElevatorUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  if Rails.env == "test"
    storage :file
  else
    storage :fog
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    'default_elevator.png'
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  # #
  # def scale(width, height)
  #   width * height
  # end

  # Create different versions of your uploaded files:
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
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
