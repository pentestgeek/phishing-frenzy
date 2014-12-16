class ClonesController < ApplicationController
  # GET /clones
  # GET /clones.json
  def index
    @clones = Clone.page(params[:page]).per(25).reverse_order
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
    page, code = clone_website(params[:clone])

    # ensure we got returned a page and status code
    return if page.nil? or code.nil?

    @clone.page = page
    @clone.status = code

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
      format.html { redirect_to clones_url, warning: 'Website Deleted' }
      format.json { head :no_content }
    end
  end

  def download
    clone = Clone.find(params[:id])
    send_data clone.page, filename: clone.url.parameterize + '.html'
  end

  def preview
    @clone = Clone.find(params[:id])
    render layout: false
  end

  private

  def clone_website(clone)
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Firefox'
    begin
      page = agent.get clone[:url]
    rescue ArgumentError => e
      redirect_to clones_path, notice: "ArgumentError: #{e}"
      return
    rescue Net::HTTP::Persistent::Error => e
      redirect_to clones_path, notice: "HTTP Issue: #{e}"
      return
    rescue Errno::ECONNRESET => e
      redirect_to clones_path, notice: "Connection Reset: #{e}"
      return
    rescue => e
      redirect_to clones_path, notice: "Issue: #{e}"
      return
    end

    doc = Nokogiri::HTML(page.content)
    doc.css("a").each do |link|
      if link.attributes['href']
        if link.attributes['href'].value[0].eql?('/')
          link.attributes['href'].value = "#{params[:clone][:url]}#{link.attributes['href'].value}"
        end
      end
    end

    doc.css("img").each do |image|
      if image.attributes['src']
        if image.attributes['src'].value[0].eql?('/')
          image.attributes['src'].value = "#{params[:clone][:url]}#{image.attributes['src'].value}"
        end
      end
    end

    return doc.to_s, page.code
  end
end
