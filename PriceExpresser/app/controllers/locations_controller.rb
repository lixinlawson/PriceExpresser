class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all
    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.latitude
      marker.lng location.longitude
      marker.infowindow (location.name + ": "+ location.address)
      marker.json({title: location.title})
    end
  end

  def walmarts
    @walmarts = Location.where(:catalog => 'walmart')
    @hash = Gmaps4rails.build_markers(@walmarts) do |location, marker|
      marker.lat location.latitude
      marker.lng location.longitude
      marker.infowindow (location.name + ": "+ location.address)
      marker.json({title: location.title})
    end
  end

  def costcos
    @costcos = Location.where(:catalog => 'costco')
    @hash = Gmaps4rails.build_markers(@costcos) do |location, marker|
      marker.lat location.latitude
      marker.lng location.longitude
      marker.infowindow (location.name + ": "+ location.address)
      marker.json({title: location.title})
    end
  end

  def bestbuys
    @bestbuys = Location.where(:catalog => 'bestbuy')
    @hash = Gmaps4rails.build_markers(@bestbuys) do |location, marker|
      marker.lat location.latitude
      marker.lng location.longitude
      marker.infowindow (location.name + ": "+ location.address)
      marker.json({title: location.title})
    end
  end

  def superstores
    @superstores = Location.where(:catalog => 'superstore')
    @hash = Gmaps4rails.build_markers(@superstores) do |location, marker|
      marker.lat location.latitude
      marker.lng location.longitude
      marker.infowindow (location.name + ": "+ location.address)
      marker.json({title: location.title})
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @hash = Gmaps4rails.build_markers(@location) do |location, marker|
    marker.lat location.latitude
    marker.lng location.longitude
    marker.infowindow location.name
    marker.json({title: location.title})
    end
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Store and Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Store and Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Store and Location was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find_by_address(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:latitude, :longitude, :address, :description, :title, :name, :phone)
    end
end
