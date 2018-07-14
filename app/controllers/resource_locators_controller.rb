class ResourceLocatorsController < ApplicationController
  before_action :set_resource_locator, only: [:show]

  # GET /resource_locators
  # GET /resource_locators.json
  def index
    @resource_locators = ResourceLocator.paginate(per_page:15, page:params[:page])
  end

  # GET /resource_locators/1
  # GET /resource_locators/1.json
   ## Action: show
    # Purpose: Redirect to given mini url if mini_url is sent.
    # URL:     /resource_locators/:id || /resource_locators/:mini_url
    # Response: it will redirect to page of given_url
    ##
  def show
    if params[:mini_url].present? 
      redirect_to @resource_locator.given_url
      @resource_locator.clicks += 1
      @resource_locator.save
    end
  end

  # GET /resource_locators/new
  def new
    @resource_locator = ResourceLocator.new
  end

   ## Action: create
    # Purpose: It will find or create Resource Locator based on given url.
    # URL:     POST /resource_locators
    # Response: It will return newly created resource locator
    ##
  def create
    @resource_locator = ResourceLocator.find_or_create_by(given_url:resource_locator_params[:given_url])
    @resource_locator.assign_attributes(resource_locator_params)
    respond_to do |format|
      if @resource_locator.save
        format.html { redirect_to @resource_locator }
        format.json { render :show, status: :created, location: @resource_locator }
      else
        flash[:error] = @resource_locator.errors.full_messages.join(",")
        format.html { redirect_to root_path }
        format.json { render json: @resource_locator.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_resource_locator
      if params[:id].present?
        @resource_locator = ResourceLocator.find(params[:id])
      elsif params[:mini_url].present?
        resource_locator_id = ResourceLocator.decode_mini_url(params[:mini_url])
        @resource_locator = ResourceLocator.find_by(resource_locator_id: resource_locator_id)
      end
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_locator_params
      params.require(:resource_locator).permit(:given_url, :mini_url, :clicks)
    end
end
