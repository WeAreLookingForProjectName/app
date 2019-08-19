# frozen_string_literal: true

class BookmarksController < ApplicationController
  before_action :set_user
  before_action -> { authorize(@user, policy_class: BookmarkPolicy) }, only: [:posts, :comments]
  before_action -> { authorize(Bookmark) }, only: [:create, :destroy]
  before_action :set_bookmarkable, only: [:create, :destroy]
  before_action :set_facade

  def posts
    @records, @pagination = posts_query.paginate(after: params[:after])
    @records = @records.map(&:bookmarkable).map(&:decorate)
  end

  def comments
    @records, @pagination = comments_query.paginate(after: params[:after])
    @records = @records.map(&:bookmarkable).map(&:decorate)
  end

  def create
    CreateBookmarkService.new(@bookmarkable, current_user).call
    @bookmarkable = @bookmarkable.decorate

    render json: {
      bookmarked: true,
      bookmark_link_tooltip_message: @bookmarkable.bookmark_link_tooltip_message
    }
  end

  def destroy
    DeleteBookmarkService.new(@bookmarkable, current_user).call
    @bookmarkable = @bookmarkable.decorate

    render json: {
      bookmarked: false,
      bookmark_link_tooltip_message: @bookmarkable.bookmark_link_tooltip_message
    }
  end

  private

  def posts_query
    BookmarksQuery.new(@user.bookmarks).posts_bookmarks.includes(bookmarkable: [:user, :community])
  end

  def comments_query
    BookmarksQuery.new(@user.bookmarks).comments_bookmarks.includes(bookmarkable: [:user, :post, :community])
  end

  def set_user
    @user = params[:user_id].present? ? UsersQuery.new.with_username(params[:user_id]).take! : current_user
  end

  def set_bookmarkable
    if params[:post_id].present?
      @bookmarkable = Post.find(params[:post_id])
    elsif params[:comment_id].present?
      @bookmarkable = Comment.find(params[:comment_id])
    end
  end
end
