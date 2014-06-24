class ClonesController < ApplicationController
  # GET /clones
  # GET /clones.json
  def index
    @clones = Clone.order("updated_at DESC")
    @clone = Clone.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clones }
    end
  end

  # GET /clones/1
  # GET /clones/1.json
  def show
    @clone = Clone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @clone }
    end
  end

  # GET /clones/new
  # GET /clones/new.json
  def new
    @clone = Clone.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @clone }
    end
  end

  # GET /clones/1/edit
  def edit
    @clone = Clone.find(params[:id])
  end

  # POST /clones
  # POST /clones.json
  def create
    @clone = Clone.new(params[:clone])

    # run the cloning magic
    page = clone_website(params[:clone])
    @clone.page = page.content
    @clone.status = page.code

    respond_to do |format|
      if @clone.save
        format.html { redirect_to clones_path, notice: 'Clone was successfully created.' }
        format.json { render json: @clone, status: :created, location: @clone }
      else
        format.html { render action: "new" }
        format.json { render json: @clone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clones/1
  # PUT /clones/1.json
  def update
    @clone = Clone.find(params[:id])

    respond_to do |format|
      if @clone.update_attributes(params[:clone])
        format.html { redirect_to @clone, notice: 'Clone was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @clone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clones/1
  # DELETE /clones/1.json
  def destroy
    @clone = Clone.find(params[:id])
    @clone.destroy

    respond_to do |format|
      format.html { redirect_to clones_url }
      format.json { head :no_content }
    end
  end

  private

  def clone_website(clone)
    agent = Mechanize.new
    page = agent.get clone[:url]
    return page
  end
end
