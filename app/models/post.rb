class Post < ActiveRecord::Base
    
    belongs_to :user
    # Each post belongs to a user
    
    validates :user, presence: true
    # method that is stating which conditions need to be met for a user to post
    
    validates :title, presence: true
    validates :body, presence: true
    # can't be created without a title and body
end
