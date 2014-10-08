class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
		sort = params[:sort] || session[:sort]
		order = params[:order] || session[:order]
		ratings = params[:ratings] || session[:ratings]
	
		if(order.nil? || order == 'DESC') 
			@order = 'ASC'
		else
			@order = 'DESC'
		end

		if(ratings.nil?) 
			@ratings = Movie.all_ratings
		else
			@ratings = ratings.keys
		end
		

		case 'title'
		when 'title'
			finder = "title"
			
		when 'release_date'
			finder = 'release_date'
		else
			@movies = Movie.all
		end
		@movies = Movie.order("#{finder} #{@order}").where("rating IN (?)", @ratings).all
    @all_ratings = Movie.all_ratings
		
		session[:sort] = sort
		session[:order] = order
		session[:ratings] = ratings		
		
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
