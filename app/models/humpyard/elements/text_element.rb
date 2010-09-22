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
      
      def html_content
        if content.blank?
          ''
        else
          if Object.const_defined?('RedCloth')
            RedCloth.new(content).to_html.html_safe
          else
            content.gsub("\n", "<br />").html_safe
          end
        end
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