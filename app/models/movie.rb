class Movie < ActiveRecord::Base
  has_many :reviews
  has_many :moviegoers, :through => :reviews, :source => :moviegoer
  has_many :recent_reviews, :class_name => 'Review', :conditions =>['created_at > ?', "#{1.week.ago}"]
  has_one  :latest_review, :class_name => 'Review', :order => 'created_at DESC'

  def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end #  shortcut: array of strings

  validates :title, :presence => true
  validates :release_date, :presence => true
  validate :released_1930_or_later # uses custom validator below
  validates :rating, :presence => true, :inclusion => {:in => Movie.all_ratings}, :unless => :grandfathered?
  def released_1930_or_later
  	errors.add(:release_date, 'must be 1930 or later') if
  	self.release_date < Date.parse('1 Jan 1930')
  end
  @@grandfathered_date = Date.parse('1 Nov 1968')
  def grandfathered? ; self.release_date >= @@grandfathered_date ; end
end
