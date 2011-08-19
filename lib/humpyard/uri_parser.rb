module Humpyard
  module UriParser
    autoload :PagesUriParser, 'humpyard/uri_parser/pages_uri_parser'
    autoload :AssetsUriParser, 'humpyard/uri_parser/assets_uri_parser'
    
    class << self    
      def parsers
        @parsers ||= [::Humpyard::UriParser::PagesUriParser, ::Humpyard::UriParser::AssetsUriParser]
      end
    
      def substitute content, options = {}
        parsers.each do |parser|
          content = parser.substitute content, options
        end
        return content
      end
    end
  end
end