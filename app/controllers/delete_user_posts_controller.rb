class DeleteUserPostsController < ApplicationController
    def delete_test
      # Trigger the execution of the DeleteUserPosts job here
      Jobs::DeleteUserPosts.new.execute({}) # Pass any necessary arguments to the execute method
  
      render json: { message: 'Job triggered successfully' }
    end
end
  