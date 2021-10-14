class Movie < ActiveRecord::Base
    
  def self.find_with_same_director(id)
    movie = self.find(id)
    
    if movie.director == 0 or movie.director == nil
      return [movie, [], true]
    end
    
    if movie.director.empty?
      return [movie, [], true]
    else
      movies = self.where(:director => movie.director)
      return [movie, movies, false]
    end
  end
end
