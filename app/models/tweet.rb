class Tweet < ActiveRecord::Base
  paginates_per 10
  belongs_to :subscription
  validates_presence_of :subscription
  default_scope order("posted_at DESC")

  def self.initialize_from_api(item)
    item = ActiveSupport::JSON.decode(item)
    self.new(
      :from_user => item["user"]["screen_name"],
      :profile_image_url => item["user"]["profile_image_url"],
      :text => item["text"],
      :posted_at => (DateTime.parse(item["created_at"]) rescue nil)
    )
  end

  def self.generate_report(tweets, file)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => 'Report Tweets'
    sheet.row(0).concat [ "Data", "Utente", "Testo" ]
    tweets.each_with_index do |tweet, index|
      sheet.row(index + 1).tap do |row|
        row.push tweet.posted_at
        row.push tweet.from_user
        row.push tweet.text
      end
    end
    book.write(file.path)
  end
end
