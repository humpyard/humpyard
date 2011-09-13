require "nokogiri"

class HtmlToTextile
  class Document < ::Nokogiri::XML::SAX::Document
    def valid_tags
      ['a','p','br','u','b','i','strong','em','ul','ol','li','sup','sub', 'ins', 'del', 'h1', 'h2', 'h3', 'table', 'tr', 'td', 'th']
    end
    
    def tree
      @tree ||= []
    end
    
    def stack
      @stack ||= []
    end
    
    def start_element name, attrs = []
      if valid_tags.include? name
        attrs_hash = {}
        while key = attrs.shift do
          value = attrs.shift
          attrs_hash[key] = value
        end
        
        
        stack << {
          'name' => name, 
          'content' => [],
          'attrs' => attrs_hash
        }
      end
    end
    
    def end_element name
      if valid_tags.include? name
        content = stack.pop
        if stack.empty? or stack.last['content'].nil?
          tree << content
        else
          stack.last['content'] << content
        end
      end
    end
    
    def characters string
      if stack.last.nil? or stack.last['content'].nil?
        stack << "#{string}"
      else
        stack.last['content'] << "#{string}"
      end
    end
    
    def to_textile  
      ##ActiveRecord::Base.logger.debug  "### tree START"
      ##ActiveRecord::Base.logger.debug  @tree.inspect
      ##ActiveRecord::Base.logger.debug  "### tree END"
      #ActiveRecord::Base.logger.debug  "### HTML START"
      to_html
      #ActiveRecord::Base.logger.debug  "### HTML END"
      
      textile = ''
      tree.each do |content|
        textile += _to_textile_tag content
      end
      
      #ActiveRecord::Base.logger.debug  "### TEXTILE START"
      #ActiveRecord::Base.logger.debug  textile
      #ActiveRecord::Base.logger.debug  "### TEXTILE END"      
      
      return textile
    end
    
    def to_html
      @html = ''
      tree.each do |content|
        _to_html_tag content
      end
      return @html
    end
    
    private
    def _to_html_tag content, indent = 0
      if content.class == String
        #ActiveRecord::Base.logger.debug "#{('  ' * indent)}#{content.to_s.gsub("\n", "#{'  ' * indent}")}"
        @html += CGI::escapeHTML "#{content}"
      elsif content.class == Hash
        if ['br','img'].include? content['name']
          #ActiveRecord::Base.logger.debug "#{('  ' * indent)}<#{content['name']} />"
          @html += "<#{content['name']} />"
        else
          #ActiveRecord::Base.logger.debug "#{('  ' * indent)}<#{content['name']}>"
          @html += "<#{content['name']}>"
          _to_html_tag(content['content'], indent + 2)
          #ActiveRecord::Base.logger.debug "#{('  ' * indent)}</#{content['name']}>"
          @html += "</#{content['name']}>"
        end
      elsif content.class == Array
        content.each do |element|
          _to_html_tag element, indent
        end
      end  
    end
    
    def _to_textile_tag content, indent = 0
      textile = ''
      if content.class == String
        ##ActiveRecord::Base.logger.debug "Content: #{content}"
        textile += "#{content}"
      elsif content.class == Hash
        if ['u','b','strong','i','em','del','ins', 'sub', 'sup'].include? content['name']
          literals = {
            'u' => '+',
            'b' => '*',
            'strong' => '*',
            'i' => '_',
            'em' => '_',
            'del' => '-',
            'ins' => '+',
            'sub' => '~',
            'sup' => '^'
          }
          inner_parsed_textile = _spaces _to_textile_tag(content['content'])
          if inner_parsed_textile[:content].blank?
            #ActiveRecord::Base.logger.debug "#{inner_parsed_textile[:leading]}#{inner_parsed_textile[:tailing]}"
            textile += "#{inner_parsed_textile[:leading]}#{inner_parsed_textile[:tailing]}"
          else
            #ActiveRecord::Base.logger.debug "#{inner_parsed_textile[:leading]}[#{literals[content['name']]}#{inner_parsed_textile[:content]}#{literals[content['name']]}]#{inner_parsed_textile[:tailing]}"
            textile += "#{inner_parsed_textile[:leading]}[#{literals[content['name']]}#{inner_parsed_textile[:content]}#{literals[content['name']]}]#{inner_parsed_textile[:tailing]}"
          end
        elsif ['br'].include? content['name']
          #ActiveRecord::Base.logger.debug "\n"
          textile += "\n"
        elsif ['p','h1','h2','h3'].include? content['name']
          if content['attrs']['style'] and a = content['attrs']['style'][/text-align:[\ ]?([^;]*)/,1] and not a.nil?
            #ActiveRecord::Base.logger.debug 'strip1'
            alignment = case a.strip.downcase
              when 'left' then '<'
              when 'right' then '>'
              when 'center' then '='
              else ''
            end
          else
            alignment = ''
          end
          #ActiveRecord::Base.logger.debug "\n#{"#{content['name']}#{alignment}. " unless indent > 0}#{_to_textile_tag(content['content'], indent).strip}#\n\n"
          textile += "\n#{content['name']}#{alignment}. " 
          textile += _to_textile_tag(content['content'], indent).strip
          textile += "\n\n"
        elsif ['a'].include? content['name']
          inner_parsed_textile = _spaces _to_textile_tag(content['content'])
          if inner_parsed_textile[:content].blank?
            #ActiveRecord::Base.logger.debug "#{inner_parsed_textile[:leading]}#{inner_parsed_textile[:tailing]}"
            textile += "#{inner_parsed_textile[:leading]}#{inner_parsed_textile[:tailing]}"
          else
            #ActiveRecord::Base.logger.debug "#{inner_parsed_textile[:leading]}[\"#{inner_parsed_textile[:content]}\":#{content['attrs']['href'].blank? ? '#' : content['attrs']['href']}]#{inner_parsed_textile[:tailing]}"
            textile += "#{inner_parsed_textile[:leading]}[\"#{inner_parsed_textile[:content]}\":#{content['attrs']['href'].blank? ? '#' : content['attrs']['href']}]#{inner_parsed_textile[:tailing]}"
          end
        elsif ['ul','ol'].include? content['name']
          literals = {
            'ul' => '*',
            'ol' => '#'
          }

          content['content'].each do |element|
            if element.class == Hash and element['name'] == 'li'
              #ActiveRecord::Base.logger.debug "\n #{literals[content['name']]} #{_to_textile_tag element, indent +2}"
              textile += "\n #{literals[content['name']]} "
              textile += _to_textile_tag element, indent +2
            end
          end
          textile += "\n"
        elsif ['table'].include? content['name']
          textile += "\n"
          content['content'].each do |row|
            if row.class == Hash and row['name'] == 'tr'
              row['content'].each do |element|
                if element.class == Hash and ['td', 'th'].include? element['name']
                  #ActiveRecord::Base.logger.debug "|#{element['name'] == 'th' ? '_.' : ''} #{_to_textile_tag(element, indent +2).strip.gsub(/\n{2,}/, "\n")} "
                  textile += "|#{element['name'] == 'th' ? '_.' : ''} #{_to_textile_tag(element, indent +2).strip.gsub(/\n{2,}/, "\n")} "
                end
              end
              textile += "|\n"      
            end
          end         
        else
          #ActiveRecord::Base.logger.debug _to_textile_tag content['content'], indent
          textile += _to_textile_tag content['content'], indent
        end
      elsif content.class == Array
        content.each do |element|
          #ActiveRecord::Base.logger.debug _to_textile_tag element, indent
          textile += _to_textile_tag element, indent
        end
      end  
      
      return textile
    end
    
    def _spaces string
      parsed = {:content => string}
      string.gsub(/^(\s*)?(\S*)(\s*)?$/) {|s| parsed = {:leading => $1, :content => $2, :tailing => $3} }
      parsed
    end
  end
  
  def initialize(string)
    @tree = []
    @document = Document.new
    parser = ::Nokogiri::HTML::SAX::Parser.new(@document)
    parser.parse(string)
  end
  
  def to_textile
    @document.to_textile
  end
  
  def to_html
    @document.to_html
  end
end