require 'test_helper'

class Humpyard::PageTest < ActiveSupport::TestCase
  test "create" do
    p = Factory.build(:page)
    assert p.valid?
  end
  
  # Human URL Tests
  
  test "simple human_url" do
    Humpyard::config.www_prefix = nil
    p = Factory.build(:page, :name => 'about')
    assert_equal '/en/about.html', p.human_url
  end
  
  test "sub page human_url" do
    Humpyard::config.www_prefix = nil
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    assert_equal '/en/about/imprint.html', p2.human_url
  end
  
  test "root page human_url" do
    Humpyard::config.www_prefix = nil
    p = Factory.build(:page, :name => 'index')
    assert_equal '/en/', p.human_url
  end
  
  test "simple human_url without www prefix" do
    Humpyard::config.www_prefix = ''
    p = Factory.build(:page, :name => 'about')
    assert_equal '/about.html', p.human_url
  end
  
  test "sub page human_url without www prefix" do
    Humpyard::config.www_prefix = ''
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    assert_equal '/about/imprint.html', p2.human_url
  end
  
  test "root page human_url without www prefix" do
    Humpyard::config.www_prefix = ''
    p = Factory.build(:page, :name => 'index')
    assert_equal '/', p.human_url
  end  
  
  test "simple human_url with custom www prefix" do
    Humpyard::config.www_prefix = 'cms/'
    p = Factory.build(:page, :name => 'about')
    assert_equal '/cms/about.html', p.human_url
  end
  
  test "sub page human_url with custom www prefix" do
    Humpyard::config.www_prefix = 'cms/'
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    assert_equal '/cms/about/imprint.html', p2.human_url
  end
  
  test "root page human_url with custom www prefix" do
    Humpyard::config.www_prefix = 'cms/'
    p = Factory.build(:page, :name => 'index')
    assert_equal '/cms/', p.human_url
  end  
  
  test "simple human_url with inline www prefix" do
    Humpyard::config.www_prefix = 'cms_'
    p = Factory.build(:page, :name => 'about')
    assert_equal '/cms_about.html', p.human_url
  end
  
  test "sub page human_url with inline www prefix" do
    Humpyard::config.www_prefix = 'cms_'
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    assert_equal '/cms_about/imprint.html', p2.human_url
  end
  
  test "root page human_url with inline www prefix" do
    Humpyard::config.www_prefix = 'cms_'
    p = Factory.build(:page, :name => 'index')
    assert_equal '/', p.human_url
  end  
  
  test "simple human_url with complex www prefix" do
    Humpyard::config.www_prefix = 'locale/:locale/cms_'
    p = Factory.build(:page, :name => 'about')
    assert_equal '/locale/en/cms_about.html', p.human_url
  end
  
  test "sub page human_url with complex www prefix" do
    Humpyard::config.www_prefix = 'locale/:locale/cms_'
    p1 = Factory.build(:page, :name => 'about')
    p2 = Factory.build(:page, :name => 'imprint', :parent => p1)
    assert_equal '/locale/en/cms_about/imprint.html', p2.human_url
  end
  
  test "root page human_url with complex www prefix" do
    Humpyard::config.www_prefix = 'locale/:locale/cms_'
    p = Factory.build(:page, :name => 'index')
    assert_equal '/locale/en/', p.human_url
  end  
  
  
end
