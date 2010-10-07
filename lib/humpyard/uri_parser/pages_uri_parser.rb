module Humpyard
  module UriParser
    class PagesUriParser
      def self.substitute content, options = {}
        content.gsub(/humpyard:\/\/page\/([0-9]*)/) do |uri| 
          begin
            "#{options[:prefix]}#{Page.find($1).human_url}#{options[:postfix]}"          
          rescue
            "#{options[:prefix]}#{Page.root_page.human_url}#{options[:postfix]}"  
          end
        end
      end
    end
  end
end