class ChildNotesController < ApplicationController
  before_action :set_child_note, only: [:show, :edit, :update, :destroy]

  # GET /child_notes
  def index
    @child_notes = ChildNote.all
  end

  # GET /child_notes/1
  def show
  end

  # GET /child_notes/new
  def new
    @child_note = ChildNote.new
  end

  # GET /child_notes/1/edit
  def edit
  end

  # POST /child_notes
  def create
    @child_note = ChildNote.new(child_note_params)

    if @child_note.save
      redirect_to @child_note, notice: 'Child note was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /child_notes/1
  def update
    if @child_note.update(child_note_params)
      redirect_to @child_note, notice: 'Child note was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /child_notes/1
  def destroy
    @child_note.destroy
    redirect_to child_notes_url, notice: 'Child note was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_child_note
      @child_note = ChildNote.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def child_note_params
      params.require(:child_note).permit(:child_id, :title, :text)
    end
end
