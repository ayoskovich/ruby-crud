# This gets created via "generate controller Products"
class ProductsController < ApplicationController
  # Allow unauth users to see index
  allow_unauthenticated_access only: %i[ index show ]

  # This runs set_product before these methods
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @products = Product.all
  end

  def show
    # Shows an individual product
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  # Note there is no "end" for private
  private
    def set_product
      @product = Product.find(params[:id])
    end
    def product_params
      # Use rails parameter filtering to only accept name
      # input
      params.expect(product: [ :name, :description, :featured_image, :inventory_count ])
    end
end
