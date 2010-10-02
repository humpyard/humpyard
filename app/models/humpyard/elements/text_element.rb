module Humpyard
  module Elements 
    ####
    # Humpyard::Elements::TextElement is a model of a text element.    
    class TextElement < ::ActiveRecord::Base
      acts_as_humpyard_element :system_element => true
      
      attr_accessible :content, :html_content
      
      require 'globalize'
      
      translates :content
      validates_presence_of :content
      
      def html_content(options = {})
        if content.blank?
          ''
        else
          if Object.const_defined?('RedCloth')
            html = RedCloth.new(content).to_html
          else
            html = content.gsub("\n", "<br />")
          end
        end
        
        if options[:parse_uris]
          html = html.gsub(/humpyard:\/\/page\/([0-9]*)/) do |uri| 
            begin
              Page.find($1).human_url              
            rescue
              Page.root_page.human_url
            end
          end
        end
        
        html.html_safe
      end

      def html_content= content
        if content.blank?
          ''
        else
          if Object.const_defined?('RedCloth')
            require 'html_to_textile'           
            self.content = HtmlToTextile.new(content.gsub("\n", ' ')).to_textile
          else
            self.content = content.gsub(/<br[^>]*>/, "\n").gsub(/<[^>]*>/, '')
          end
        end
      end
    end
  end
end