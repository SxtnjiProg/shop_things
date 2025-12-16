class ImageUploader < CarrierWave::Uploader::Base
  # Використовуємо :file для локального зберігання
  storage :file

  # Директорія, куди будуть зберігатися файли
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  # Обмеження на розширення файлів
  def extension_allowlist
    %w(jpg jpeg gif png)
  end
  
  
end