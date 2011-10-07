class Post < ActiveRecord::Base
  belongs_to :user
  has_many :votes, :dependent => :destroy

  validates_presence_of :user
end
