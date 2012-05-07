class Picture < ActiveRecord::Base

  include Rails.application.routes.url_helpers
  mount_uploader :file, AvatarUploader

  public
  def to_jq_upload
    {
      "file" => read_attribute(:file),
      "size" => file.size,
      "url" => file.url,
      "thumbnail_url" => "/assets/24.png",
      "delete_url" => uploader_picture_path(:id => id),
      "delete_type" => "DELETE" 
    }
  end

  def to_jq_upload_enc
    {
      "file" => read_attribute(:file),
      "size" => file.size,
      "url" => file.url,
      "thumbnail_url" => "/assets/Security-Lock.png",
      "delete_url" => uploader_picture_path(:id => id),
      "delete_type" => "DELETE"
    }
  end
end