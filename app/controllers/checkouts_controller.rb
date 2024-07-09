class CheckoutsController < ApplicationController

def create
  stripe_secret_key = Rails.application.credentials.dig(:stripe, :secret_key)
  Stripe.api_key = stripe_secret_key
  cart = params[:cart]

  # Array to hold line items for Stripe checkout session
  line_items = []

  cart.each do |item|
    product = Product.find(item["id"])

    # Find the appropriate stock for the product and size
    product_stock = product.stocks.find{ |ps| ps.size == item["size"] }

    if product_stock.nil?
      render json: { error: "Stock information not found for #{product.name} in size #{item["size"]}." }, status: 400
      return
    end

    if product_stock.amount.nil? || product_stock.amount < item["quantity"].to_i
      render json: { error: "Not enough stock for #{product.name} in size #{item["size"]}. Only #{product_stock.amount || 0} left." }, status: 400
      return
    end

    # Add line item for Stripe session
    line_items << {
      quantity: item["quantity"].to_i,
      price_data: {
        product_data: {
          name: item["name"],
          metadata: { product_id: product.id, size: item["size"], product_stock_id: product_stock.id }
        },
        currency: "usd",
        unit_amount: item["price"].to_i
      }
    }
  end

  # Create a Stripe Checkout session with line items
  session = Stripe::Checkout::Session.create(
    mode: "payment",
    line_items: line_items,
    success_url: "http://localhost:3000/success",
    cancel_url: "http://localhost:3000/cancel",
    shipping_address_collection: {
      allowed_countries: ['US', 'CA']
    }
  )

  render json: { url: session.url }
end


  def success
    render :success
  end

  def cancel
    render :cancel
  end
end
