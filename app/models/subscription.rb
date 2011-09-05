class Subscription < ActiveRecord::Base
  paginates_per 10
  validates_uniqueness_of :query

  def to_s
    query
  end
end
