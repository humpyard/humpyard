module Humpyard
  module UriParser
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