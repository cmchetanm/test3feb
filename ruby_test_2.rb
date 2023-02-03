class String
  def string_between_markers marker1, marker2
    self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
  end
end
# Install the google-drive-ruby gem
# gem install google-drive-ruby

# Setup authentication with your Google Drive account
require 'google_drive'
session = GoogleDrive::Session.from_config("config.json")

# Get the folder from your Google Drive account
folder = session.collection_by_url("https://drive.google.com/drive/folders/1v8kAzirygnGsKm4X0eX_OhNgFPw865aQ")

# Download all the files in the folder
info = []
folder.files.each do |file|
  ff = file.download_to_file("#{File.basename(file.title)}")
  reader = PDF::Reader.new(ff.expand_path)
  if reader.info[:Title].include?("Judgment for Costs of Appointed Attorney")
    info << {
      petitioner: reader.pages.map {|a| a.text}.first.split.join(' ').string_between_markers('the State of Alaska ', ', Jr., Supreme Court No.'),
      state: reader.pages.map {|a| a.text}.first.split.join(' ').string_between_markers('Appointed Attorney', ', Appellate Rule '),
      amount: reader.pages.map {|a| a.text}.first.split.join(' ').string_between_markers('pay to appellee ', ', a reduced amount'),
      date: reader.pages.map {|a| a.text}.first.split.join(' ').string_between_markers('date of Notice: ', ' Trial Court Case No'),
    }
  end
end



