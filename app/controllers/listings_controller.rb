class ListingsController < ApplicationController
    # only allows access to this page after after logging in
    before_action :authenticate_user!, only: [:new, :edit]
    # shows all listing available 
    def index
      @listings = Listing.all
    end
    
    def new
      @listing = Listing.new
     end
    # method to create new items for the user logged in
     def create
        @listing = current_user.listings.new(listing_params)
        if @listing.save
            redirect_to @listing
        else 
            render :new
        end
     end
     
    def edit
        
    end
    # method to show details of listing
    def show
        @listing = Listing.find(params[:id])

    end
    # adding layer of security with srong params to avoid malicious editing
    private

    def listing_params
        params.require(:listing).permit(:name,:price,:description,:item_condition)
    end

end
