# encoding: utf-8
CarrierWave::SanitizedFile.sanitize_regexp = /[^a-zA-Zа-яА-ЯёЁ0-9\ \(\)\.\-\+_]/u
class AvatarUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "FILES/#{model.user_id}/"
  end
end