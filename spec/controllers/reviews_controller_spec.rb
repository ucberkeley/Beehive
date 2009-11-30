require 'spec_helper'

describe ReviewsController do

  before(:each) do
	@controller.stub!(:login_required).and_return(true)
  end
  
  def mock_review(stubs={})
    @mock_review ||= mock_model(Review, stubs)
  end

  describe "GET index" do
    it "assigns all reviews as @reviews" do
      Review.stub!(:find).with(:all).and_return([mock_review])
      get :index
      assigns[:reviews].should == [mock_review]
    end
  end

  describe "GET show" do
    it "assigns the requested review as @review" do
      Review.stub!(:find).with("37").and_return(mock_review)
      get :show, :id => "37"
      assigns[:review].should equal(mock_review)
    end
  end

  describe "GET new" do
    it "assigns a new review as @review" do
      Review.stub!(:new).and_return(mock_review)
      get :new
      assigns[:review].should equal(mock_review)
    end
  end

  describe "GET edit" do
    it "assigns the requested review as @review" do
      Review.stub!(:find).with("37").and_return(mock_review)
      get :edit, :id => "37"
      assigns[:review].should equal(mock_review)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created review as @review" do
        Review.stub!(:new).with({'these' => 'params'}).and_return(mock_review(:save => true))
        post :create, :review => {:these => 'params'}
        assigns[:review].should equal(mock_review)
      end

      it "redirects to the created review" do
        Review.stub!(:new).and_return(mock_review(:save => true))
        post :create, :review => {}
        response.should redirect_to(review_url(mock_review))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved review as @review" do
        Review.stub!(:new).with({'these' => 'params'}).and_return(mock_review(:save => false))
        post :create, :review => {:these => 'params'}
        assigns[:review].should equal(mock_review)
      end

      it "re-renders the 'new' template" do
        Review.stub!(:new).and_return(mock_review(:save => false))
        post :create, :review => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested review" do
        Review.should_receive(:find).with("37").and_return(mock_review)
        mock_review.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :review => {:these => 'params'}
      end

      it "assigns the requested review as @review" do
        Review.stub!(:find).and_return(mock_review(:update_attributes => true))
        put :update, :id => "1"
        assigns[:review].should equal(mock_review)
      end

      it "redirects to the review" do
        Review.stub!(:find).and_return(mock_review(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(review_url(mock_review))
      end
    end

    describe "with invalid params" do
      it "updates the requested review" do
        Review.should_receive(:find).with("37").and_return(mock_review)
        mock_review.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :review => {:these => 'params'}
      end

      it "assigns the review as @review" do
        Review.stub!(:find).and_return(mock_review(:update_attributes => false))
        put :update, :id => "1"
        assigns[:review].should equal(mock_review)
      end

      it "re-renders the 'edit' template" do
        Review.stub!(:find).and_return(mock_review(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested review" do
      Review.should_receive(:find).with("37").and_return(mock_review)
      mock_review.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the reviews list" do
      Review.stub!(:find).and_return(mock_review(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(reviews_url)
    end
  end

end
