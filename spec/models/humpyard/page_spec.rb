require 'spec_helper'

describe Humpyard::Page do
  it "create" do
    p = Factory.build(:page)
    p.valid?.should == true
  end
  
  # Human URL Tests
  
  it "simple human_url" do
    Humpyard::config.www_prefix = nil
    p = Factory.build(:page, :name => 'about')
    p.human_url.should == '/en/about.html'
  end
  
  it "sub page human_url" do
    Humpyard::config.www_prefix = nil
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    p2.human_url.should == '/en/about/imprint.html'
  end
  
  it "root page human_url" do
    Humpyard::config.www_prefix = nil
    p = Factory.build(:page, :name => 'index')
    p.human_url.should == '/en/'
  end
  
  it "simple human_url without www prefix" do
    Humpyard::config.www_prefix = ''
    p = Factory.build(:page, :name => 'about')
    p.human_url.should == '/about.html'
  end
  
  it "sub page human_url without www prefix" do
    Humpyard::config.www_prefix = ''
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    p2.human_url.should == '/about/imprint.html'
  end
  
  it "root page human_url without www prefix" do
    Humpyard::config.www_prefix = ''
    p = Factory.build(:page, :name => 'index')
    p.human_url.should == '/'
  end  
  
  it "simple human_url with custom www prefix" do
    Humpyard::config.www_prefix = 'cms/'
    p = Factory.build(:page, :name => 'about')
    p.human_url.should == '/cms/about.html'
  end
  
  it "sub page human_url with custom www prefix" do
    Humpyard::config.www_prefix = 'cms/'
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    p2.human_url.should == '/cms/about/imprint.html'
  end
  
  it "root page human_url with custom www prefix" do
    Humpyard::config.www_prefix = 'cms/'
    p = Factory.build(:page, :name => 'index')
    p.human_url.should == '/cms/'
  end  
  
  it "simple human_url with inline www prefix" do
    Humpyard::config.www_prefix = 'cms_'
    p = Factory.build(:page, :name => 'about')
    p.human_url.should == '/cms_about.html'
  end
  
  it "sub page human_url with inline www prefix" do
    Humpyard::config.www_prefix = 'cms_'
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    p2.human_url.should == '/cms_about/imprint.html'
  end
  
  it "root page human_url with inline www prefix" do
    Humpyard::config.www_prefix = 'cms_'
    p = Factory.build(:page, :name => 'index')
    p.human_url.should == '/'
  end  
  
  it "simple human_url with complex www prefix" do
    Humpyard::config.www_prefix = 'locale/:locale/cms_'
    p = Factory.build(:page, :name => 'about')
    p.human_url.should == '/locale/en/cms_about.html'
  end
  
  it "sub page human_url with complex www prefix" do
    Humpyard::config.www_prefix = 'locale/:locale/cms_'
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    p2.human_url.should == '/locale/en/cms_about/imprint.html'
  end
  
  it "root page human_url with complex www prefix" do
    Humpyard::config.www_prefix = 'locale/:locale/cms_'
    p = Factory.build(:page, :name => 'index')
    p.human_url.should == '/locale/en/'
  end
end