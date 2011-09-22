# coding=utf-8

require 'spec_helper'

describe Humpyard::Page do
  
  it "should pass validation when a new page is created from factory" do
    p = Factory.build(:page)
    p.valid?.should eql true
  end
  
  describe "validation" do
    it "should fail validation when no title is given" do
      p = Factory.build(:page, :title => nil)
      p.valid?.should eql false
    end
  
    it "should fail validation when empty title is given" do
      p = Factory.build(:page, :title => '')
      p.valid?.should eql false
    end
  
    it "should fail validation when given display_from is after given display_until" do
      p = Factory.build(:page)
      p.display_from = Time.zone.now + 1.week
      p.display_until = Time.zone.now - 1.week
      p.valid?.should eql false
    end
  
    it "should pass validation when only display_from is given" do
      p = Factory.build(:page)
      p.display_from = Time.zone.now + 1.week
      p.valid?.should eql true
    end
  
    it "should pass validation when only display_until is given" do
      p = Factory.build(:page)
      p.display_until = Time.zone.now + 1.week
      p.valid?.should eql true
    end
  
    it "should pass validation when given display_until is after given display_from" do
      p = Factory.build(:page)
      p.display_from = Time.zone.now - 1.week
      p.display_until = Time.zone.now + 1.week
      p.valid?.should eql true
    end
  end  

  describe "suggested_title_for_url" do
    before :all do
      Humpyard::Page.destroy_all
      @root_page = Humpyard::Page.create! :title => 'Startpage'
    end
    
    it "should give itself sane names if uniqueness not met" do
      Humpyard::Page.destroy_all
      p = Factory :page, :title=>'My great page'
      p.title_for_url.should eql 'index'
      p = Factory :page, :title=>'My great page'
      p.title_for_url.should eql 'my-great-page'
      p = Factory :page, :title=>'My great page'
      p.title_for_url.should eql 'my-great-page-'
    end
  
    it "should give itself names with some special chars" do
      p = Factory.build :page
      p.title = 'Das Überwebseite'
      p.suggested_title_for_url.should eql 'das-uberwebseite'
      p.title = 'Eine kleine Seite über mich'
      p.suggested_title_for_url.should eql 'eine-kleine-seite-uber-mich'
      p.title = 'Smá síðu um mig'
      p.suggested_title_for_url.should eql 'sma-sidu-um-mig'
      p.title = 'Hakkımda Biraz sayfa'
      p.suggested_title_for_url.should eql 'hakkimda-biraz-sayfa'
      # not really nice, but better than nothing
      p.title = 'Немного обо мне страницы'
      p.suggested_title_for_url.should eql '%D0%9D%D0%B5%D0%BC%D0%BD%D0%BE%D0%B3%D0%BE-%D0%BE%D0%B1%D0%BE-%D0%BC%D0%BD%D0%B5-%D1%81%D1%82%D1%80%D0%B0%D0%BD%D0%B8%D1%86%D1%8B'
    end
    
    it "should give itself names in many locales" do
      I18n.locale = :en
      about_page = Humpyard::Page.create! :title => 'About', :parent => @root_page
      about_page.title_for_url.should eql 'about'
      I18n.locale = :de
      about_page.update_attribute :title, 'Über'
      about_page.title_for_url.should eql 'uber'
      I18n.locale = :en
      about_page.title_for_url.should eql 'about'
      about_page.destroy
    end
    
    it "should give itself names for many locales manually" do
      I18n.locale = :en
      about_page = Humpyard::Page.new :title => 'About', :parent => @root_page
      I18n.locale = :de
      about_page.title = 'Über'
      I18n.locale = :en
      about_page.suggested_title_for_url.should eql 'about'
      about_page.suggested_title_for_url(:de).should eql 'uber'
    end
  end
  
  describe "human_url" do
    before(:all) do
      I18n.locale = :en
      Humpyard::Page.destroy_all
      @root_page = Humpyard::Page.create! :title => 'Startpage'
      # FactoryGirl does not like to play in more than one language
      # @about_page = Factory(:page, :title => 'About', :parent => @root_page)
      @about_page = Humpyard::Page.create! :title => 'About', :parent => @root_page
      I18n.locale = :de
      @about_page.update_attribute :title, 'Über'
      I18n.locale = :en
      @imprint_page = Factory(:page, :title => 'imprint', :parent => @about_page)
    end
    
    after(:all) do
      @root_page.destroy
      @about_page.destroy
      @imprint_page.destroy   
    end
    
    it "should work on root page with some www_prefixes" do
      Humpyard::config.locales = 'en'
      Humpyard::config.www_prefix = nil
      @root_page.human_url.should eql '/en/'
      Humpyard::config.www_prefix = ''
      @root_page.human_url.should eql '/'
      Humpyard::config.www_prefix = 'cms/'
      @root_page.human_url.should eql '/cms/'
      Humpyard::config.www_prefix = 'cms_'
      @root_page.human_url.should eql '/'
      Humpyard::config.www_prefix = 'locale/:locale/cms_'
      @root_page.human_url.should eql '/locale/en/'
    end

    it "should work on a simple page with some www_prefixes" do
      Humpyard::config.www_prefix = nil
      @about_page.human_url.should eql '/en/about.html'
      Humpyard::config.www_prefix = ''
      @about_page.human_url.should eql '/about.html'
      Humpyard::config.www_prefix = 'cms/'
      @about_page.human_url.should eql '/cms/about.html'
      Humpyard::config.www_prefix = 'cms_'
      @about_page.human_url.should eql '/cms_about.html'
      Humpyard::config.www_prefix = 'locale/:locale/cms_'
      @about_page.human_url.should eql '/locale/en/cms_about.html'
    end

    it "should work on a sub page with some www_prefixes" do
      Humpyard::config.www_prefix = nil
      @imprint_page.human_url.should eql '/en/about/imprint.html'
      Humpyard::config.www_prefix = ''
      @imprint_page.human_url.should eql '/about/imprint.html'
      Humpyard::config.www_prefix = 'cms/'
      @imprint_page.human_url.should eql '/cms/about/imprint.html'
      Humpyard::config.www_prefix = 'cms_'
      @imprint_page.human_url.should eql '/cms_about/imprint.html'
      Humpyard::config.www_prefix = 'locale/:locale/cms_'
      @imprint_page.human_url.should eql '/locale/en/cms_about/imprint.html'
    end

    it "should fall back to first allowed locale when given not allowed locale " do
      Humpyard::config.www_prefix = nil
      I18n.locale = :de
      @about_page.human_url.should eql '/en/about.html'
    end
  
    it "should work on a page with allowed custom locale, but no given translation" do
      Humpyard::config.locales = 'en,fr,de'
      I18n.locale = :fr
      @about_page.human_url.should eql '/fr/about.html'
    end
  
    it "should work on a page with allowed custom locale and given translation" do
      I18n.locale = :de
      @about_page.human_url.should eql '/de/uber.html'
      I18n.locale = :en
      @about_page.human_url.should eql '/en/about.html'
    end

    it "should work on a page with allowed custom locale as option with many locales configured" do
      I18n.locale = :en
      @about_page.human_url(:locale => :de).should eql '/de/uber.html'
    end
  
    it "should fallback to first locale with many locales configured on a page when given not allowed custom locale as I18n.locale" do
      I18n.locale = :cn
      @about_page.human_url.should eql '/en/about.html'
    end
  
    it "should fallback to first locale with many locales configured on a page when given not allowed custom locale as option" do
      I18n.locale = :fr
      @about_page.human_url(:locale => :cn).should eql '/en/about.html'
    end
    
    
  end
  
  describe "last_modified" do
    it "should respond to last_modified with the mtime of Rails.root if it is later than the combination of itself and the contained elements" do
      p = Factory(:static_page, :updated_at => rails_root_mtime - 1.minute)
      p.page.update_attribute :updated_at, rails_root_mtime - 1.minute
      Factory(:element, :updated_at => rails_root_mtime - 2.minutes, :page => p.page)
      Factory(:element, :updated_at => rails_root_mtime - 3.minutes, :page => p.page)
      p.last_modified.should eql rails_root_mtime
    end

    it "should respond to last_modified with the timestamp of the latest element update" do
      p = Factory(:static_page, :updated_at => rails_root_mtime + 1.minute)
      p.page.update_attribute :updated_at, rails_root_mtime - 1.minute
      Factory(:element, :updated_at => rails_root_mtime + 2.minutes, :page => p.page)
      Factory(:element, :updated_at => rails_root_mtime + 3.minutes, :page => p.page)
      p.last_modified.should eql rails_root_mtime + 3.minutes
    end
  
    it "should respond to last_modified with the timestamp of itself if there are no elements on the page" do
      p = Factory(:static_page, :updated_at => rails_root_mtime + 1.minute)
      p.page.update_attribute :updated_at, rails_root_mtime - 1.minute
      p.last_modified.should eql rails_root_mtime + 1.minute
    end
  
    it "should respond to last_modified with the timestamp of itself if it is newer than all elements on the page" do
      p = Factory(:static_page, :updated_at => rails_root_mtime + 1.minute)
      p.page.update_attribute :updated_at, rails_root_mtime - 1.minute
      Factory(:element, :updated_at => rails_root_mtime, :page => p.page)
      Factory(:element, :updated_at => rails_root_mtime, :page => p.page)
      p.last_modified.should eql rails_root_mtime + 1.minute
    end
  end
  
  describe "template_name" do
    it "should respond with the template name if it is set" do
      p = Factory(:static_page, :template_name => "test_template")
      p.template_name.should eql "test_template"
    end
    it "should respond with the configured humpyard default template name if its not set" do
      p = Factory(:static_page, :template_name => nil)
      p.template_name.should eql "application"
    end
  end
    
  describe "root_elements" do
    it "should return a list of elements including those shared from siblings" do
      parent = Factory(:static_page)
      subpage1 = Factory(:static_page, :parent => parent.page)
      subpage2 = Factory(:static_page, :parent => parent.page)
      e1 = Factory(:element, :page => subpage1.page, :shared_state => Humpyard::Element::SHARED_STATES[:shared_on_siblings])
      parent.page.root_elements.should eql []
      subpage1.page.root_elements.should eql [e1]
      subpage2.page.root_elements.should eql [e1]
    end
    it "should return a list of elements including those shared from parents" do
      parent = Factory(:static_page)
      subpage1 = Factory(:static_page, :parent => parent.page)
      subpage2 = Factory(:static_page, :parent => parent.page)
      e1 = Factory(:element, :page => parent.page, :shared_state => Humpyard::Element::SHARED_STATES[:shared_on_children])
      parent.page.root_elements.should eql [e1]
      subpage1.page.root_elements.should eql [e1]
      subpage2.page.root_elements.should eql [e1]
    end
  end
end
