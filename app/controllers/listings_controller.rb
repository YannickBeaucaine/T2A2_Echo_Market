class ListingsController < ApplicationController
    # only allows access to this page after after logging in
    before_action :authenticate_user!, only: [:new, :edit, :create]
    before_action :set_listing, only: [:show, :edit, :update, :destroy, :deactivate]
    # shows all listing available and adds method to search function
    def index
        if params[:query].present?
             @listings = Listing.search_by_name(params[:query]).includes(:user)
        else
            @listings = Listing.where.not(status: "purchased") 
        end
    end
   
    def new

      @listing = Listing.new

    end
    # method to create new listing for the user logged in
     def create
        @listing = current_user.listings.build(listing_params)
        @listing.status = 1
        if @listing.save
            redirect_to @listing
            flash[:success] = "Listing was successfully created."
        else
            render :new
        end
     end
  
    
    # logic controller method to edit listed item 
    def edit
        authorize! :update, @listing
    end
    # logic controller to update listed item
    def update
        authorize! :update, @listing
       if @listing.update(listing_params)
        redirect_to @listing
       else
        render :edit
       end
    end
    # method to show details of listing activating Stripe
    def show
        
        stripe_session = Stripe::Checkout::Session.create( 
         payment_method_types:['card'],
         client_reference_id: current_user.id,
         customer_email: current_user.email,
         line_items:[{
           amount: (@listing.price * 100).to_i, 
           name: @listing.name,
           description: @listing.description,
           currency: 'aud',
           quantity: '1',
           images: @listing.images.empty? ? nil : [@listing.images.first.service_url]
         }],
         payment_intent_data: {
             metadata: {
                 listing_id: @listing.id,
                 user_id: current_user.id
             }
         },
         success_url: "#{root_url}purchases/success?listingId=#{@listing.id}",
         cancel_url: "#{root_url}listings"
         )
         @session_id = stripe_session.id
         
    end
    # method to delete listed item
    def destroy
        @listing.destroy
        flash[:alert] = 'Your listing has been removed'
        redirect_to listings_path
    end

    
  
  
    #strong params
    private

    def listing_params
        params.require(:listing).permit(:name,:price,:description,:item_condition,:images)
    end

    def set_listing
        @listing = Listing.find(params[:id])
    end

end
