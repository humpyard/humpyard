module Humpyard

  class PublishRangeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if attribute == :display_from and not record.display_from.blank? and not record.display_until.blank? and record.display_until < record.display_from
        record.errors.add attribute, :cannot_be_after_display_until
      end
      if attribute == :display_until and not record.display_until.blank? and not record.display_from.blank? and record.display_until <= record.display_from
        record.errors.add attribute, :cannot_be_before_display_from
      end
    end
  end

end
