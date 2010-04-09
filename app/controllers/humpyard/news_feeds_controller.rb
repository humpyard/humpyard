module Humpyard
  ####
  # Humpyard::NewsFeedsController is the controller for editing and viewing news feeds
  class NewsFeedsController < ::ApplicationController
  
    def index
      @news_feeds = Humpyard::NewsFeed.all
      @news_feed = Humpyard::NewsFeed.first
      render :partial => 'index'
    end

    # Dialog content for a new news feed
    def new
      @news_feed = Humpyard::NewsFeed.new
      render :partial => 'edit'
    end
    
    # Create a new news feed
    def create
      @news_feed = Humpyard::NewsFeed.new params[:news_feed]
      
      if @news_feed.save
        render :json => {
          :status => :ok,
          :dialog => :close,
        }
      else
        render :json => {
          :status => :failed, 
          :errors => @news_feed.errors
        }
      end
    end
    
    # Update an existing news feed
    def update
      @news_feed = Humpyard::NewsFeed.find(params[:id])
      if @news_feed
        if @news_feed.update_attributes params[:news_feed]
          @news_feed.save
          render :json => {
            :status => :ok,
          }
        else
          render :json => {
            :status => :failed, 
            :errors => @news_feed.errors
          }
        end
      else
        render :json => {
          :status => :failed
        }, :status => 404
      end
    end

  end
end