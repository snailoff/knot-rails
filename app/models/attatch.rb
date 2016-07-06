class Attatch < ActiveRecord::Base
	belongs_to :knot

	has_attached_file :file, styles: { medium: "480x480>", thumb: "150x150>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/
end
