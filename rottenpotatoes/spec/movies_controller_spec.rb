require 'spec_helper'
require 'rails_helper.rb'

describe MoviesController, :type => :controller do
  
  describe 'Search movies by the same director' do
    
    it 'should call Movie.similar_movies that finds movies with same director' do
      Movie.should_receive(:find_with_same_director).with("Titanic")
      get :similar, {:id => 'Titanic'}
    end
    
    it 'when the specified movie has a director, it should select similar template' do
      Movie.stub(:find_with_same_director).and_return(nil,nil,false)
      get :similar, {:id => "Aladdin"}
      expect(response).to render_template('similar')
    end
    
    it 'should assign similar movies and/or template if the director exists' do
      movie = double('Movie', :title => 'Aladdin', :id => 'main')
      Movie.stub(:find_with_same_director).and_return([movie, nil, false])
      get :similar, {:id => 'main'}
      assigns(:movie).should == movie
    end
    
    it 'should redirect to main page if director is not known' do
      movie = double('Movie', :title => 'No name')
      Movie.stub(:find_with_same_director).with('No name').and_return([movie,nil,true])
      get :similar, {:id => 'No name'}
      expect(response).to redirect_to(movies_path)
    end
    
  end
end