module Humpyard

  class PublishRangeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if attribute == :display_from and not record.display_from.nil? and not record.display_until.nil? and record.display_until < record.display_from
        record.errors.add attribute, :cannot_be_after_display_until
      end
      if attribute == :display_until and not record.display_until.nil? and not record.display_from.nil? and record.display_until <= record.display_from
        record.errors.add attribute, :cannot_be_before_display_from
      end
    end
  end

end
