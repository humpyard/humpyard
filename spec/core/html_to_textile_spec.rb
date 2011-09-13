require 'spec_helper'
require 'html_to_textile'    

def transform_html html
  HtmlToTextile.new(html).to_textile
end

describe HtmlToTextile do
  context 'to_textile' do
    it 'should transform paragraphs' do
      transform_html('<p>Para 1</p><p>Para 2</p>').should == "p. Para 1\n\np. Para 2\n\n"
    end
    
    it 'should align text left via CSS' do
      transform_html('<p style="text-align: left;">Left</p>').should == "p<. Left\n\n"
    end
    
    it 'should align text centered via CSS' do
      transform_html('<p style="text-align: center;">Center</p>').should == "p=. Center\n\n"
    end
    
    it 'should align text right via CSS' do
      transform_html('<p style="text-align: right;">Right</p>').should == "p>. Right\n\n"
    end
    
    it 'should format text bold' do
      transform_html('<p><b>Bold</b> and <strong>Strong</strong> should work</p>').should == "p. [*Bold*] and [*Strong*] should work\n\n"
    end
    
    it 'should format text italic' do
      transform_html('<p><i>Italic</i> and <em>Emphasize</em> should work</p>').should == "p. [_Italic_] and [_Emphasize_] should work\n\n"
    end

    it 'should format text super and subline' do
      transform_html('<p><sup>Super</sup> and <sub>Subline</sub> should work</p>').should == "p. [^Super^] and [~Subline~] should work\n\n"
    end
    
    it 'should format text del and ins' do
      transform_html('<p><del>Deleted</del> and <ins>Inserted</ins> should work</p>').should == "p. [-Deleted-] and [+Inserted+] should work\n\n"
    end
    
    it 'should format text with different styles' do
      transform_html('<p>This is <em>very <strong>important</strong></em> stuff</p>').should == "p. This is [_very [*important*]_] stuff\n\n"
    end
        
    it 'should transform links' do
      transform_html('See <a href="http://humpyard.org">Humpyard</a> for more.').should == "p. See [\"Humpyard\":http://humpyard.org] for more.\n\n"
    end
    
    it 'should remove empty links' do
      transform_html(' See <a href="http://humpyard.org"></a> for more. ').should == "p. See  for more.\n\n"
    end
    
    it 'should transform unordered lists' do
      transform_html('<p>A list like</p><ul><li>One</li><li>Two</li></ul><p>should work</p>').should == "p. A list like\n\n\n * One\n * Two\np. should work\n\n"
    end
    
    it 'should transform ordered lists' do
      transform_html('<p>A list like</p><ol><li>One</li><li>Two</li></ol><p>should work</p>').should == "p. A list like\n\n\n # One\n # Two\np. should work\n\n"
    end
    
    it 'should not accept p in td' do
      transform_html('A Table <table><tr><th><p>Head</p></th><td><p>Data</p></td></tr></table><p> is this.</p>').should == "p. A Table\n\n|_. Head | Data |\np. is this.\n\n"
    end
    
    it 'should preserve escaped tags in strings' do
      transform_html("<p>\nThis is a '&lt;script&gt;do_evil();&lt;/script&gt;' css attack\n</p>").should == "p. This is a '&lt;script&gt;do_evil();&lt;/script&gt;' css attack\n\n"
    end
  end
end