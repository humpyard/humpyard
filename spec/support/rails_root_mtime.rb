def rails_root_mtime
  Time.zone.at(::File.new("#{Rails.root}").mtime)
end