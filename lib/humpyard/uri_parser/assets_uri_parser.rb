module Humpyard
  module UriParser
    class AssetsUriParser
      def self.substitute content, options = {}
        content.gsub(/humpyard:\/\/asset\/([0-9]*)/) do |uri| 
          begin
            "#{options[:prefix]}#{Asset.find($1).url}#{options[:postfix]}"  
          rescue
            ''
          end
        end
      end
    end
  end
end