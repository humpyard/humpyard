module Humpyard
  module PagesHelper
    def page_body(options={}, &block)
      render partial: '/humpyard/common/page_construct', locals: {options: options, block: block}
    end
    
    def title(page_title)
      @content_for_title = page_title.to_s
    end

    def stylesheet(*args)
      content_for(:head) { stylesheet_link_tag(*args) }
    end

    def javascript(*args)
      content_for(:head) { javascript_include_tag(*args) }
    end
  end
end