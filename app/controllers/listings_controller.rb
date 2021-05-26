class ListingsController < ApplicationController
    # only allows access to this page after after logging in
    before_action :authenticate_user!, only: [:new, :edit]
    # shows all listing available 
    def index
      @listings = Listing.all
    end
    # method to create new items
    def new
      @listing = Listing.new

    end

    def edit
        
    end
    # method to show details of listing
    def show
        @listing = Listing.find(params[:id])

    end

end
