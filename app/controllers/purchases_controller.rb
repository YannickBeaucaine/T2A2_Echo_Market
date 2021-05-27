class PurchasesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:webhook]
    # controller method for succesful payment when stripe purchase completed
    def success
        @listing = Listing.find(params[:listingId])
    end
    # controller method for stripe and ultrahook
    def webhook
        payment_intent_id = params[:data][:object][:payment_intent]
        payment = Stripe::PaymentIntent.retrieve(payment_intent_id)
        listing_id = payment.metadata.listing_id
        buyer_id = payment.metadata.user_id
    
    puts '-' * 20
    puts listing_id
    puts buyer_id
    puts '-' * 20


    Purchase.create(
        user_id: buyer_id, 
        listing_id: listing_id, 
        payment_intent_id: payment_intent_id, 
        receipt_url: payment.charges.data[0].receipt_url
    )
    
    listing = Listing.find(listing_id)
    listing.update(status: 'purchased')

    end
end
