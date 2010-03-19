require 'spec_helper'

describe Humpyard::Config do
  # www_prefix option
  it "has default www_prefix" do
    Humpyard::config.www_prefix.should eql ':locale/'
  end
  
  it "allows custom www_prefix" do
    Humpyard::config.www_prefix = 'cms/'
    Humpyard::config.www_prefix.should eql 'cms/'
  end
  
  it "allows resetting to default www_prefix" do
    Humpyard::config.www_prefix = nil
    Humpyard::config.www_prefix.should eql ':locale/'
  end
  
  # admin_prefix option
  
  it "has default admin_prefix" do
    Humpyard::config.admin_prefix.should eql 'admin'
  end
  
  it "allows custom admin_prefix" do
    Humpyard::config.admin_prefix = 'cms_admin'
    Humpyard::config.admin_prefix.should eql 'cms_admin'
  end
  
  it "allows resetting to default admin_prefix" do
    Humpyard::config.admin_prefix = nil
    Humpyard::config.admin_prefix.should eql 'admin'
  end
  
  # table_name_prefix option
  
  it "has default table_name_prefix" do
    Humpyard::config.table_name_prefix.should eql 'humpyard_'
  end
  
  it "allows custom table_name_prefix" do
    Humpyard::config.table_name_prefix = 'cms_'
    Humpyard::config.table_name_prefix.should eql 'cms_'
  end
  
  it "allows resetting to default table_name_prefix" do
    Humpyard::config.table_name_prefix = nil
    Humpyard::config.table_name_prefix.should eql 'humpyard_'
  end
  
  # locales option
  
  it "has default locales" do
    Humpyard::config.locales.should eql ['en']
  end
  
  it "allows custom locales as array" do
    Humpyard::config.locales = ['en', 'de', 'fr']
    Humpyard::config.locales.should eql ['en', 'de', 'fr']
  end

  it "allows custom locales as string" do
    Humpyard::config.locales = "de,fr,cn"
    Humpyard::config.locales.should eql ['de', 'fr', 'cn']
  end

  it "allows resetting to default locales" do
    Humpyard::config.locales = nil
    Humpyard::config.locales.should eql ['en']
  end
  
  it "allows adding a locale" do
    Humpyard::config.locales = 'en,fr'
    Humpyard::config.locales << 'de'
    Humpyard::config.locales.should eql ['en', 'fr', 'de']
  end
  
  it "allows adding a locale to default" do
    Humpyard::config.locales = nil
    Humpyard::config.locales << 'de'
    Humpyard::config.locales.should eql ['en', 'de']
  end
  
  # configure
  
  it "does configure" do
    Humpyard.configure do |config|
      config.www_prefix = 'cms/'
      config.admin_prefix = 'cms/admin'
      config.table_name_prefix = 'cms_'
      config.locales = 'en,de'
    end
    Humpyard::config.www_prefix.should eql 'cms/'
    Humpyard::config.admin_prefix.should eql 'cms/admin'
    Humpyard::config.table_name_prefix.should eql 'cms_'
    Humpyard::config.locales.should eql ['en','de']
  end

end