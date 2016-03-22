class Post < ActiveRecord::Base
    attr_accessor :tag_titles
    
    belongs_to :user
    # Each post belongs to a user
    
    # Contains many categotization models
    has_many :categorizations
    
    # Contains many tags, organized through categorizations database
    # In that database, each categorization links a post ID with a tag ID 
    has_many :tags, through: :categorizations
    
    validates :user, presence: true
    # method that is stating which conditions need to be met for a user to post
    
    validates :title, presence: true
    validates :body, presence: true
    # can't be created without a title and body
end
