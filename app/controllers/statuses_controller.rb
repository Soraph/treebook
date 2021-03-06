class StatusesController < ApplicationController

  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  # GET /statuses
  # GET /statuses.json
  def index
    @statuses = Status.all.reverse_order

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @statuses }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
    @status = Status.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.json
  def new
    @status = Status.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/1/edit
  def edit
    @status = Status.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = current_user.statuses.new(status_params)

    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: 'Status was successfully created.' }
        format.json { render json: @status, status: :created, location: @status }
      else
        format_generic_error("new")
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.json
  def update
    @status = current_user.statuses.find(params[:id])
    
    if params[:status] && params[:status].has_key?(:user_id)
      params[:status].delete(:user_id) 
    end

    respond_to do |format|
      if @status.update_attributes(status_params)
        format.html { redirect_to @status, notice: 'Status was successfully updated.' }
        format.json { head :no_content }
      else
        format_generic_error("edit")
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status = current_user.statuses.find(params[:id])

    respond_to do |format|
      if @status.destroy
        format.html { redirect_to statuses_url, notice: 'Status was successfully deleted.' }
        format.json { head :no_content }
      else
        format_generic_error("index")
      end
    end
  end

  private
  def status_params
    params.require(:status).permit(:content, :user_id)
  end

  def format_generic_error(type)
    format.html { render action: type }
    format.json { render json: @status.errors, status: :unprocessable_entity }
  end
end
