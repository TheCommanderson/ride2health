# frozen_string_literal: true

class DriversController < UsersController
  skip_before_action :authorized, only: %i[create new]
  before_action :set_driver, only: %i[show edit update destroy approve]

  # GET /drivers or /drivers.json
  def index
    @drivers = Driver.all
  end

  # GET /drivers/1 or /drivers/1.json
  def show; end

  # GET /drivers/new
  def new
    @driver = Driver.new
  end

  # GET /drivers/1/edit
  def edit; end

  # POST /drivers or /drivers.json
  def create
    @driver = Driver.new(driver_params)

    respond_to do |format|
      begin
        if @driver.save
          format.html { redirect_to @driver, notice: 'driver was successfully created.' }
          format.json { render :show, status: :created, location: @driver }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @driver.errors, status: :unprocessable_entity }
        end
      rescue ArgumentError
        flash.now[:danger] = 'Please ensure all fields are filled in.'
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1 or /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params)
        format.html { redirect_to @driver, notice: 'driver was successfully updated.' }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivers/1 or /drivers/1.json
  def destroy
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'driver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve
    @driver.update_attribute(:trained, !@driver.trained)
    if @driver.trained && @driver.update_attribute(:sysadmin, current_user)
      flash[:info] = 'Approved!'
    elsif !@driver.trained && @driver.unset(:sysadmin)
      flash[:info] = 'Driver unapproved successfully.'
    else
      flash[:danger] = 'There was an error (un)approving this driver, please try again.'
    end
    redirect_to root_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_driver
    @driver = Driver.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def driver_params
    params.require(:driver).permit(
      :first_name,
      :middle_init,
      :last_name,
      :phone,
      :email,
      :password,
      :password_confirmation,
      :car_make,
      :car_model,
      :car_color,
      :car_license_plate
    )
  end
end
