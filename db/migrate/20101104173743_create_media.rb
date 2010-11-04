class CreateMedia < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string     :title
      t.integer    :width
      t.integer    :height
      t.references :content_data
      t.string     :content_data_type
      t.timestamps
    end
    
    create_table :assets_paperclip_assets do |t|
      t.string     :media_file_name
      t.integer    :media_file_size
      t.string     :media_content_type
      t.datetime   :media_updated_at
      t.timestamps
    end
    
    create_table :assets_youtube_assets do |t|
      t.string     :youtube_video_id
      t.string     :youtube_title
      t.timestamps
    end
    
    create_table :elements_media_elements do |t|
      t.references :asset
      t.string     :float
      t.timestamps
    end
  end
  
  def self.down
    
  end 
end