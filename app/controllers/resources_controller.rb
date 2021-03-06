class ResourcesController < ApplicationController
  # GET /resources
  # GET /resources.json
  def index

    if params[:course_id]
      @resources = Course.find(params[:course_id]).resources.page(params[:page])
    elsif params[:activity_id]
      @resources = Activity.find(params[:activity_id]).resources.page(params[:page])
    else
      @resources = Resource.all.page(params[:page])
    end

    drop_breadcrumb("Resources")    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resources }
    end
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
    @resource = Resource.find(params[:id])

    drop_breadcrumb("Resources", resources_path)
    drop_breadcrumb(@resource.name)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/new
  # GET /resources/new.json
  def new
    @resource = Resource.new    

    drop_breadcrumb("Resources", resources_path)
    drop_breadcrumb("New resource")

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/1/edit
  def edit
    @resource = Resource.find(params[:id])

    drop_breadcrumb("Resources", resources_path)
    drop_breadcrumb(@resource.name, resources_path(@resource))
    drop_breadcrumb("Edit")

  end

  # POST /resources
  # POST /resources.json
  def create
    @resource = Resource.new(params[:resource])

    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource, notice: 'Resource was successfully created.' }
        format.json { render json: @resource, status: :created, location: @resource }
      else
        format.html { render action: "new" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /resources/1
  # PUT /resources/1.json
  def update
  	params[:resource][:course_ids] ||= []
    @resource = Resource.find(params[:id])

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        format.html { redirect_to @resource, notice: 'Resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to resources_url }
      format.json { head :no_content }
    end
  end

  # GET /resources/?search
  # GET /resources.json/?search
  def search
    @resources = Resource.where(name: /#{Regexp.escape(params[:q])}/).page(params[:page])

    drop_breadcrumb("Resources", resources_path)
    drop_breadcrumb("Search")

    respond_to do |format|
      format.html
      format.json { render json: @resources }
    end    
  end
end
