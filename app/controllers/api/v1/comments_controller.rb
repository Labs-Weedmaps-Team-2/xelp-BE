module Api
    module V1
        class CommentsController < ApplicationController
            def index
                @comments = Comment.all

                render json: @comments
            end

            def create
                @business = Business.find(params[:business_id])
                @comment = @business.comments.create(comment_params)
                redirect_to business_path(@business)

                render json @comment
            end
        
            def update
                @comment = Comment.update(comment_params)

                render json @comment
            end

            def destroy
                @business = Business.find(params[:business_id])
                @comment = @business.comments.find(params[:id])
                @comment.destroy
            end

            private

            def set_comment
                @comment = Comment.find(params[:id])
            end
            
            def comment_params
                params.require(:comment).permit(:id, :title, :body)
            end

            def format_comment(business) {
                id: comment.id,
                title: comment.title,
                body: comment.body
            }
        end
    end
end

  
