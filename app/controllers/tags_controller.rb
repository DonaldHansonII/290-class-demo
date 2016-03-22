class TagsController < InheritedResources::Base

  private

    def tag_params
      params.require(:tag).permit(:title)
    end
end

