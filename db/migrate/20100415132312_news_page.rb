class NewsPage < ActiveRecord::Migration
  def change
    # create_table :pages_news_pages do |t|
    #   t.timestamps
    #   t.datetime :deleted_at
    # end
    # 
    # create_table :elements_news_elements do |t|
    #   t.references :news_page
    #   t.timestamps
    # end
    #     
    # create_table :news_items do |t|
    #   t.references :news_page
    #   t.datetime :published_at
    #   t.timestamps
    #   t.datetime :deleted_at
    # end
    # 
    # create_table :news_item_translations do |t|
    #   t.references :"#{Humpyard::config.table_name_prefix}news_items"
    #   t.string :locale
    #   t.string :title
    #   t.string :title_for_url 
    #   t.text :description 
    #   t.timestamps
    # end
  end
end