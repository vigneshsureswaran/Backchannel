class User < ActiveRecord::Base
  has_many :posts, :dependent => :destroy
  has_many :votes, :dependent => :destroy

  validates_uniqueness_of :username
  validates_confirmation_of :password, :on => :create
  validates_length_of :password, :within => 5..40
  validates_presence_of :username
  validates_presence_of :password
  validates_presence_of :fullname


end
