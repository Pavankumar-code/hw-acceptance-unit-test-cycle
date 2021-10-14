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
      response.should render_template('similar')
    end
    
    it 'should make the movies with same director available to that template' do
      fake_movie = double('Movie')
      fake_results = [double('Movie'), double('Movie')]
      Movie.stub(:find_with_same_director).and_return([fake_movie, fake_results, false])
      get :similar, {:id => 1}
      assigns(:movie).should == fake_movie
      assigns(:movies).should == fake_results
    end
    
    it 'should select the Index page to redirect to when movie has no director' do
      fake_movie = double('Movie', :title => 'Aladdin')
      Movie.stub(:find_with_same_director).and_return([fake_movie,nil,true])
      get :similar, {:id => 1}
      response.should redirect_to movies_path
    end
    
    it 'should make the error message available to that template' do
      fake_movie = double('Movie', :title => 'Aladdin')
      Movie.stub(:find_with_same_director).and_return([fake_movie, nil, true])
      get :similar, {:id => 1}
      flash[:notice].should eq("'#{fake_movie.title}' has no director info")
    end
    
  end
end