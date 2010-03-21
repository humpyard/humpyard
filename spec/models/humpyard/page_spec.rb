require 'spec_helper'

describe Humpyard::Page do
  
  before(:all) do
    @rails_root_mtime = Time.zone.at(::File.new("#{Rails.root}").mtime)
  end
  
  it "creates a new page from factory" do
    p = Factory.build(:page)
    p.valid?.should eql true
  end
  
  # Human URL Tests
  
  it "gets human_url on a simple page name" do
    Humpyard::config.www_prefix = nil
    p = Factory.build(:page, :name => 'about')
    p.human_url.should eql '/en/about.html'
  end
  
  it "gets human_url on a sub page name" do
    Humpyard::config.www_prefix = nil
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    p2.human_url.should eql '/en/about/imprint.html'
  end
  
  it "gets human_url on the root page" do
    Humpyard::config.www_prefix = nil
    p = Factory.build(:page, :name => 'index')
    p.human_url.should eql '/en/'
  end
  
  it "gets human_url on a simple page name without www prefix" do
    Humpyard::config.www_prefix = ''
    p = Factory.build(:page, :name => 'about')
    p.human_url.should eql '/about.html'
  end
  
  it "gets human_url on a sub page name without www prefix" do
    Humpyard::config.www_prefix = ''
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    p2.human_url.should eql '/about/imprint.html'
  end
  
  it "gets human_url on the root page without www prefix" do
    Humpyard::config.www_prefix = ''
    p = Factory.build(:page, :name => 'index')
    p.human_url.should eql '/'
  end  
  
  it "gets human_url on a simple page name with custom www prefix" do
    Humpyard::config.www_prefix = 'cms/'
    p = Factory.build(:page, :name => 'about')
    p.human_url.should eql '/cms/about.html'
  end
  
  it "gets human_url on a sub page name with custom www prefix" do
    Humpyard::config.www_prefix = 'cms/'
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    p2.human_url.should eql '/cms/about/imprint.html'
  end
  
  it "gets human_url on the root page with custom www prefix" do
    Humpyard::config.www_prefix = 'cms/'
    p = Factory.build(:page, :name => 'index')
    p.human_url.should eql '/cms/'
  end  
  
  it "gets human_url on a simple page name with inline www prefix" do
    Humpyard::config.www_prefix = 'cms_'
    p = Factory.build(:page, :name => 'about')
    p.human_url.should eql '/cms_about.html'
  end
  
  it "gets human_url on a sub page name with inline www prefix" do
    Humpyard::config.www_prefix = 'cms_'
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    p2.human_url.should eql '/cms_about/imprint.html'
  end
  
  it "gets human_url on the root page with inline www prefix" do
    Humpyard::config.www_prefix = 'cms_'
    p = Factory.build(:page, :name => 'index')
    p.human_url.should eql '/'
  end  
  
  it "gets human_url on a simple page name with complex www prefix" do
    Humpyard::config.www_prefix = 'locale/:locale/cms_'
    p = Factory.build(:page, :name => 'about')
    p.human_url.should eql '/locale/en/cms_about.html'
  end
  
  it "gets human_url on a sub page name with complex www prefix" do
    Humpyard::config.www_prefix = 'locale/:locale/cms_'
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    p2.human_url.should eql '/locale/en/cms_about/imprint.html'
  end
  
  it "gets human_url on the root page with complex www prefix" do
    Humpyard::config.www_prefix = 'locale/:locale/cms_'
    p = Factory.build(:page, :name => 'index')
    p.human_url.should eql '/locale/en/'
  end
  
  it "gets human_url on a page with allowed custom locale" do
    Humpyard::config.www_prefix = nil
    Humpyard::config.locales = 'en'
    p = Factory.build(:page, :name => 'about')
    p.human_url.should eql '/en/about.html'
  end
  
  it "gets human_url on a page with not allowed custom locale as I18n.locale and fallback to first locale" do
    Humpyard::config.www_prefix = nil
    Humpyard::config.locales = 'en'
    I18n.locale = :de
    p = Factory.build(:page, :name => 'about')
    p.human_url.should eql '/en/about.html'
  end
  
  it "gets human_url on a page with allowed custom locale as I18n.locale with many locales configured" do
    Humpyard::config.www_prefix = nil
    Humpyard::config.locales = 'en,fr,de'
    I18n.locale = :de
    p = Factory.build(:page, :name => 'about')
    p.human_url.should eql '/de/about.html'
  end
  
  it "gets human_url on a page with allowed custom locale as option with many locales configured" do
    Humpyard::config.www_prefix = nil
    Humpyard::config.locales = 'en,fr,de'
    I18n.locale = :en
    p = Factory.build(:page, :name => 'about')
    p.human_url(:locale => :de).should eql '/de/about.html'
  end
  
  it "gets human_url on a page with not allowed custom locale as I18n.locale and fallback to first locale with many locales configured" do
    Humpyard::config.www_prefix = nil
    Humpyard::config.locales = 'de,en,fr'
    I18n.locale = :cn
    p = Factory.build(:page, :name => 'about')
    p.human_url.should eql '/de/about.html'
  end
  
  it "gets human_url on a page with not allowed custom locale as option and fallback to first locale with many locales configured" do
    Humpyard::config.www_prefix = nil
    Humpyard::config.locales = 'en,fr,de'
    I18n.locale = :fr
    p = Factory.build(:page, :name => 'about')
    p.human_url(:locale => :cn).should eql '/en/about.html'
  end
  
  # last_modified tests
  it "responds to last_modified with the mtime of Rails.root if it is later than the combination of itself and the contained elements" do
    p = Factory(:page, :updated_at => @rails_root_mtime - 1.minute)
    Factory(:element, :updated_at => @rails_root_mtime - 2.minutes, :page => p)
    Factory(:element, :updated_at => @rails_root_mtime - 3.minutes, :page => p)
    p.last_modified.should eql (@rails_root_mtime)
  end

  it "responds to last_modified with the timestamp of the latest element update" do
    p = Factory(:page, :updated_at => @rails_root_mtime + 1.minute)
    Factory(:element, :updated_at => @rails_root_mtime + 2.minutes, :page => p)
    Factory(:element, :updated_at => @rails_root_mtime + 3.minutes, :page => p)
    p.last_modified.should eql (@rails_root_mtime + 3.minutes)
  end
  
  it "responds to last_modified with the timestamp of itself if there are no elements on the page" do
    p = Factory(:page, :updated_at => @rails_root_mtime + 1.minute)
    p.last_modified.should eql (@rails_root_mtime + 1.minute)
  end
  
  it "responds to last_modified with the timestamp of itself if it is newer than all elements on the page" do
    p = Factory(:page, :updated_at => @rails_root_mtime + 1.minute)
    Factory(:element, :updated_at => @rails_root_mtime, :page => p)
    Factory(:element, :updated_at => @rails_root_mtime, :page => p)
    p.last_modified.should eql (@rails_root_mtime + 1.minute)
  end
  
end