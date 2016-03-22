class Tag < ActiveRecord::Base
    # Title of each tag is unique 
    validates :title, presence: true, uniqueness: true
end
