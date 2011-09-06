class Subscription < ActiveRecord::Base
  paginates_per 10
  validates_uniqueness_of :query
  validates_presence_of :query
  has_many :tweets, :dependent => :destroy

  def match?(tweet)
    query.downcase.split(/\s*,\s*/).any? do |words|
      words = words.split(/\s+/)
      words.all? { |word| tweet.text.downcase.split(/\W/).include?(word) }
    end
  end

end
