class ChildPhotosController < ApplicationController
  before_action :set_child_photo, only: [:show, :edit, :update, :destroy]

  # GET /child_photos
  # GET /child_photos.json
  def index
    @child_photos = ChildPhoto.all
  end

  # GET /child_photos/1
  # GET /child_photos/1.json
  def show
  end

  # GET /child_photos/new
  def new
    @child_photo = ChildPhoto.new
  end

  # GET /child_photos/1/edit
  def edit
  end

  # POST /child_photos
  # POST /child_photos.json
  def create
    @child_photo = ChildPhoto.new(child_photo_params)

    respond_to do |format|
      if @child_photo.save
        format.html { redirect_to @child_photo, notice: 'Child photo was successfully created.' }
        format.json { render :show, status: :created, location: @child_photo }
      else
        format.html { render :new }
        format.json { render json: @child_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /child_photos/1
  # PATCH/PUT /child_photos/1.json
  def update
    respond_to do |format|
      if @child_photo.update(child_photo_params)
        format.html { redirect_to @child_photo, notice: 'Child photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @child_photo }
      else
        format.html { render :edit }
        format.json { render json: @child_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /child_photos/1
  # DELETE /child_photos/1.json
  def destroy
    @child_photo.destroy
    respond_to do |format|
      format.html { redirect_to child_photos_url, notice: 'Child photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_child_photo
      @child_photo = ChildPhoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def child_photo_params
      params.require(:child_photo).permit(:child_id, :description, :key, :row_order)
    end
end
