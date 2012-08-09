module Humpyard
  module ActiveRecord
    module Has
      module TitleForUrl
        def self.included(base)
          base.extend ClassMethods
          base.before_save :assign_title_for_url         
        end

        module ClassMethods
          def find_by_title_for_url(url, options = {})
            options[:locale] ||= ::I18n.locale

            unless Humpyard::config.locales.include? options[:locale].to_sym
              options[:locale] = Humpyard::config.locales.first
            end
            
            if options[:skip_fallbacks]
              locales = [options[:locale].to_sym]
            else
              locales = [options[:locale].to_sym] + (Humpyard::config.locales.map{|l| l.to_sym} - [options[:locale].to_sym])
            end
            
            locales.each do |l|
              #t = self.with_locale(l){find_first_by_translated_attr_and_locales(:title_for_url, url)}
              t = self.translation_class.where('locale = ? AND title_for_url = ?', l.to_s, url.to_s).first
              
              if t
                return self.find(t["#{self.name.underscore.gsub('/', '_')}_id"])
              end
            end
            
            nil
          end       
        end
   
        def query_title_for_url(locale = I18n.locale)
          given = translations.all
          ([locale.to_sym] + (Humpyard::config.locales.map{|l| l.to_sym} - [locale.to_sym])).each do |l|
            t = given.select{|tx| tx.locale.to_sym == l}.first
            return t.title_for_url if t and not t.title_for_url.blank?
          end    
          nil 
        end
        
        def suggested_title_for_url(locale = I18n.locale)
          return nil if title.blank?
          
          title_for_url = (self.title(locale) ? self.title(locale) : self.title).parameterize('-').to_s
          
          # Check if parameterized totally failed
          if title_for_url == ''
            title_for_url = CGI::escape(self.title.gsub(/[a-z0-9\-_\x00-\x7F]+/, '-'))
          end 
          
          root_page = Humpyard::Page.root_page
          
          while obj = self.class.find_by_title_for_url(title_for_url, skip_fallbacks: true, locale: locale) and 
            obj.id != self.id and 
            (
              not obj.respond_to?(:parent_id) or
              obj.parent_id == self.parent_id or 
              (obj.parent_id.nil? and self.parent_id == root_page.id) or 
              (self.parent_id.nil? and obj.parent_id == root_page.id)
            ) do
            title_for_url += '-'
          end
          return title_for_url
        end

        protected
        def assign_title_for_url
          self.title_for_url = suggested_title_for_url
        end     
      end
    end
  end
end

class ActiveRecord::Base
  def self.has_title_for_url(options = {})
    include Humpyard::ActiveRecord::Has::TitleForUrl
  end
end