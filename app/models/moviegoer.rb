class Moviegoer < ActiveRecord::Base
	has_many :reviews
	has_many :movies, :through => :reviews, :source => :movie

  attr_protected :uid, :provider, :name
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end
end

