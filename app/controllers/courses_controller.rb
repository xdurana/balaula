class CoursesController < ApplicationController
  # GET /courses
  # GET /courses.json
  def index

    if params[:resource_id]
      @courses = Resource.find(params[:resource_id]).courses.page(params[:page])
    else
      @courses = Course.all.page(params[:page])
    end

    drop_breadcrumb("Courses")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])

    drop_breadcrumb("Courses", courses_path)
    drop_breadcrumb(@course.name)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = Course.new

    drop_breadcrumb("Courses", courses_path)
    drop_breadcrumb("New course")    

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])

    drop_breadcrumb("Courses", courses_path)
    drop_breadcrumb(@course.name, courses_path(@course))
    drop_breadcrumb("Edit")    
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    params[:course][:resource_ids] ||= []
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end

  # GET /courses/?search
  # GET /courses.json/?search
  def search
    @courses = Course.where(name: /#{Regexp.escape(params[:q])}/).page(params[:page])

    drop_breadcrumb("Courses", courses_path)
    drop_breadcrumb("Search")

    respond_to do |format|
      format.html
      format.json { render json: @courses }
    end    
  end  

end
