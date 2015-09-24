class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all.pluck(:rating).uniq
    
    if !params[:sort_col].nil?
      @sorted_col = params[:sort_col]
      session[:sort_col] = params[:sort_col]
    elsif !session[:sort_col].nil?
      @sorted_col = session[:sort_col]
    else
      @sorted_col = nil
    end

    if !params[:ratings].nil?
      @selected_ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif params[:ratins].nil? and params[:commit] == "Refresh"
      @selected_ratings = nil
      session[:ratings] = nil
    elsif !session.nil?
      @selected_ratings = session[:ratings]
    else
      @selected_ratings = nil
    end

    @movies = Movie.all

    if !@selected_ratings.nil?
      @movies = @movies.select {|m| @selected_ratings.include? m.rating}    
    end     
    if !@sorted_col.nil?
      @movies = @movies.sort_by {|hsh| hsh[@sorted_col.to_sym]}
    end         
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end