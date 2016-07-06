class AddAttachmentImageToAttatches < ActiveRecord::Migration
  def self.up
    change_table :attatches do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :attatches, :file
  end
end
