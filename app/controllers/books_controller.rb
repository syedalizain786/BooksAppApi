class BooksController < ApplicationController
    before_action :authentication

    def index
        @books=Book.all
        render json: @books
    end

    
    def show
    @book=Book.find(params[:id])
    render json: @book

    end

    def create
    @book=Book.create(
        title:params[:title],
        summary:params[:summary],
        date:params[:date]
    )
    render json: @book
    end

    def update
    @book=Book.find(params[:id])
    @book.update(
        title:params[:title],
        summary:params[:summary],
        date:params[:date]
    )
    render json: @book
    end

    def destroy
    @book=Book.find(params[:id])
    @book.destroy
    render json:@book
    end

    def destroy_all
        @book=Book.destroy_all
        
        render json:@book
    
    end
end
