class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id, :include => 'reviews') # look up movie by unique ID
    @reviews = @movie.reviews
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:order => :title}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:order => :release_date}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    if params[:sort] != session[:sort]
      session[:sort] = sort
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
  end

  # as a reminder, here is the original 'new' method:
  def new
    @movie = Movie.new
  end

  # replaces the 'create' method in controller:
  def create
    @movie = Movie.new(params[:movie])
    if @movie.save
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    else
      render 'new' # note, 'new' template can access @movie's field values!
    end
  end

  def edit
    @movie = Movie.find params[:id]
  end

  # replaces the 'update' method in controller:
  def update
    @movie = Movie.find params[:id]
    if @movie.update_attributes(params[:movie])
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    else
      render 'edit' # note, 'edit' template can access @movie's field values!
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
