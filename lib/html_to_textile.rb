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
          #value = attrs.shift
          attrs_hash[key[0]] = key[1]
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
      to_html
      textile = ''
      tree.each do |content|
        textile += _to_textile_tag content
      end
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
        @html += "#{content}"
      elsif content.class == Hash
        if ['br','img'].include? content['name']
          @html += "<#{content['name']} />"
        else
          @html += "<#{content['name']}>"
          _to_html_tag(content['content'], indent + 2)
          @html += "</#{content['name']}>"
        end
      elsif content.class == Array
        content.each do |element|
          _to_html_tag element, indent
        end
      end  
    end
    
    def _to_textile_tag content, indent = 0, options = {}
      
      options[:allowed_tags] ||= %w(u b strong i em del ins sub sup br p h1 h2 h3 a ul ol table)
      
      textile = ''
      if content.class == String
        textile += CGI::escapeHTML "#{content}"
      elsif content.class == Hash
        if options[:allowed_tags].include? content['name']
          if %w(u b strong i em del ins sub sup).include? content['name']
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
            inner_parsed_textile = _spaces _to_textile_tag(content['content'], 0, options)
            if inner_parsed_textile[:content].blank?
              textile += "#{inner_parsed_textile[:leading]}#{inner_parsed_textile[:tailing]}"
            else
              textile += "#{inner_parsed_textile[:leading]}[#{literals[content['name']]}#{inner_parsed_textile[:content]}#{literals[content['name']]}]#{inner_parsed_textile[:tailing]}"
            end
          elsif %w(br).include? content['name']
            textile += "\n"
          elsif %w(p h1 h2 h3).include? content['name']
            if content['attrs']['style'] and a = content['attrs']['style'][/text-align:[\ ]?([^;]*)/,1] and not a.nil?
              alignment = case a.strip.downcase
                when 'left' then '<'
                when 'right' then '>'
                when 'center' then '='
                else ''
              end
            else
              alignment = ''
            end
            textile += "\n" unless textile.empty? and indent == 0
            textile += "#{content['name']}#{alignment}. " 
            textile += _to_textile_tag(content['content'], indent, options).strip
            textile += "\n\n"
          elsif %w(a).include? content['name']
            inner_parsed_textile = _spaces _to_textile_tag(content['content'], 0, options)
            if inner_parsed_textile[:content].blank?
              textile += "#{inner_parsed_textile[:leading]}#{inner_parsed_textile[:tailing]}"
            else
              textile += "#{inner_parsed_textile[:leading]}[\"#{inner_parsed_textile[:content]}\":#{content['attrs']['href'].blank? ? '#' : content['attrs']['href']}]#{inner_parsed_textile[:tailing]}"
            end
          elsif %w(ul ol).include? content['name']
            literals = {
              'ul' => '*',
              'ol' => '#'
            }

            content['content'].each do |element|
              if element.class == Hash and element['name'] == 'li'
                textile += "\n #{literals[content['name']]} "
                textile += _to_textile_tag element, indent +2, options
              end
            end
            textile += "\n"
          elsif %w(table).include? content['name'] 
            textile += "\n" unless textile.empty? and indent == 0
            content['content'].each do |row|
              if row.class == Hash and row['name'] == 'tr'
                row['content'].each do |element|
                  if element.class == Hash and %w(td th).include? element['name']
                    table_options = options
                    table_options[:allowed_tags] -= %w(p table)
                    textile += "|#{element['name'] == 'th' ? '_.' : ''} #{_to_textile_tag(element, indent +2, options).strip.gsub(/\n{2,}/, "\n")} "
                  end
                end
                textile += "|\n"      
              end
            end       
          end  
        else
          textile += _to_textile_tag content['content'], indent, options
        end
      elsif content.class == Array
        content.each do |element|
          textile += _to_textile_tag element, indent, options
        end
      end  
      
      return textile
    end
    
    def _spaces string
      parsed = {content: string}
      string.gsub(/^(\s*)?(\S*)(\s*)?$/) {|s| parsed = {leading: $1, content: $2, tailing: $3} }
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