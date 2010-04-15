class PageI18nName < ActiveRecord::Migration
  def self.up
    begin
      add_column :page_translations, :title_for_url, :string
      Humpyard::Page.reset_column_information
    
      rename_column :page_translations, :humpyard_page_id, :page_id
      Humpyard::Page.all.each do |p|
        Humpyard::config.locales.each do |locale|
          I18n.locale = locale
          p.title_for_url = p.suggested_title_for_url
          p.save
        end
      end
      I18n.locale = Humpyard::config.locales.first
      rename_column :page_translations, :page_id, :humpyard_page_id
      remove_column :pages, :name, :string
      Humpyard::Page.reset_column_information
    rescue
    end
  end
  
  def self.down

  end 
end