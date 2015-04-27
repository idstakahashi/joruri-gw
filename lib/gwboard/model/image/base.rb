module Gwboard::Model::Image::Base
  extend ActiveSupport::Concern

  included do
    attr_accessor :file, :file_data

    before_validation :set_values_from_file
    before_validation :set_values_from_doc
    after_create :upload_internal_file
    after_destroy :remove_internal_file

    validates :file, presence: { message: "を指定してください。" }, on: :create
    validate :validate_content_type, on: :create

    with_options if: :control_related? do |f|
      f.after_create :update_file_size_currently
      f.after_destroy :update_file_size_currently
      f.validate :validate_file_size_limit
    end
  end

  def is_image
    true
  end

  def graphic_size_label
    is_image ? "（#{self.width} x #{self.height}）" : ''
  end

  def eng_unit
    ApplicationController.helpers.number_to_human_size(self.size)
  end

  def regulate_size(dst_w = 720)
    src_w = self.width.to_f
    src_h = self.height.to_f
    if src_w != 0
      src_r = (dst_w.to_f / src_w)
      dst_h = src_h * src_r
    else
      dst_w = 0
      dst_h = 0
    end
    {:width => dst_w.ceil, :height => dst_h.ceil}
  end

  def reduced_size(options = {})
    src_w = self.width.to_f
    src_h = self.height.to_f
    dst_w = options[:width].to_f
    dst_h = options[:height].to_f
    if src_h != 0
      src_r = (src_w / src_h)
      dst_r = (dst_w / dst_h)
      if dst_r > src_r
        dst_w = (dst_h * src_r)
      else
        dst_h = (dst_w / src_r)
      end
    else
      dst_w = 0
      dst_h = 0
    end

    case options[:output]
    when :css
      "width: #{dst_w.ceil}px; height:#{dst_h.ceil}px;"
    else
      {:width => dst_w.ceil, :height => dst_h.ceil}
    end
  end

  def base_dir
    "#{Rails.root}/public/_common/modules/#{system_name}"
  end

  def f_path
    if self.parent_name.to_s.size == 8
      "#{base_dir}/#{sprintf('%06d', self.title_id)}/#{parent_id_dir}/#{self_id_dir}/"
    else
      "#{base_dir}/#{sprintf('%06d', self.title_id)}/#{self.parent_name}/"
    end
  end

  def f_name
    "#{f_path}#{self.filename}"
  end

  def file_uri
    if self.parent_name.to_s.size == 8
      "/_common/modules/#{system_name}/#{sprintf('%06d', self.title_id)}/#{parent_id_dir}/#{self_id_dir}/#{URI.encode(self.filename)}"
    else
      "/_common/modules/#{system_name}/#{sprintf('%06d', self.title_id)}/#{self.parent_name}/#{self.filename}"
    end
  end

  def image_file_path
    file_uri
  end

  def save(args = {})
    super(args)
  rescue => e
    if e.class == Errno::ENAMETOOLONG
      errors.add(:base, "ファイル名が長すぎます。(#{self.filename})")
    else
      errors.add(:base, e.to_s)
    end
    return false
  end

  private

  def public_base_dir
    "#{Rails.root}/public#{file_base_path}"
  end

  def upload_base_dir
    "#{Rails.root}/upload#{file_base_path}"
  end

  def parent_id_dir
    Util::CheckDigit.check(format('%07d', self.parent_id))
  end

  def self_id_dir
    str = sprintf("%08d", self.id)
    "#{str[0..3]}/#{str[4..7]}"
  end

  def set_values_from_doc
    if doc
      self.parent_name = doc.name
      self.title_id = doc.title_id
    end
    self.latest_updated_at = Time.now
  end

  def set_values_from_file
    return unless self.file

    self.content_type = self.file.content_type
    self.filename = self.file.original_filename
    self.size = self.file.size
    #self.unid = 2
    self.width = 0
    self.height = 0

    self.file_data = self.file.read

    if self.content_type =~ /^image/
      begin
        require 'RMagick'
        image = Magick::Image.from_blob(self.file_data).shift
        if image.format =~ /(GIF|JPEG|PNG)/
          #self.unid = 1
          self.width = image.columns
          self.height = image.rows
        end
      rescue
      end
    end
  end

  def internal_file_related?
    self.db_file_id.present? && self.db_file_id <= 0
  end

  def upload_internal_file
    FileUtils.mkdir_p(f_path) unless FileTest.exist?(f_path)
    File.open(f_name, "wb") { |f| f.write(self.file_data) }
  end

  def remove_internal_file
    FileUtils.remove_entry(f_path)
  rescue => e
    error_log e.to_s
  end

  def control_related?
    self.class.reflect_on_association(:control).present?
  end

  def validate_file_size_limit
    return unless self.file

    max_size = control.upload_graphic_file_size_max || 3

    if max_size.megabytes < self.file.size
      file_size_in_mb = sprintf("%.2f", self.file.size.to_f / 1.megabyte.to_f)
      errors.add :base, "ファイルサイズが制限を超えています。【最大#{max_size}MBの設定です。】【#{file_size_in_mb}MBのファイルを登録しようとしています。】"
    end
  end

  def validate_content_type
    return unless self.file

    if content_type =~ /bmp/i
      errors.add :base, '記事の画像はBMP形式以外のフォーマットをご利用ください。'
    end
    if content_type !~ /^image/i
      errors.add :base, '記事に掲載する画像以外のファイルは添付機能をご利用ください。'
    end
  end

  def update_file_size_currently
    control.update_columns(
      upload_graphic_file_size_currently: self.class.where(title_id: self.title_id).sum(:size).to_f
    )
  end
end
