# frozen_string_literal: true

class PatientsController < UsersController
  before_action :set_patient, only: %i[show edit update destroy]
  skip_before_action :authorized, only: %i[new create]

  # GET /patients
  def pending; end

  # GET /patients.json
  def index
    # TODO(spencer) clean this up
    @currentPatient = current_user
    @patients = Patient.all
    @appointments = Appointment.where('patient_id' => current_user.id).sort_by(&:datetime)
    @drivers = Driver.all
    @dt_format = dt_format
  end

  # GET /patients/1
  # GET /patients/1.json
  def show; end

  # GET /patients/new
  def new
    @patient = Patient.new
  end

  # GET /patients/1/edit
  def edit; end

  # POST /patients
  # POST /patients.json
  def create
    @patient = Patient.new(patient_params)

    respond_to do |format|
      begin
        if @patient.save
          # AdminMailer.with(patient: @patient).new_patient_email.deliver
          format.html { redirect_to @patient, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @patient }
        else
          format.html { render :new }
          format.json { render json: @patient.errors, status: :unprocessable_entity }
        end
      rescue ArgumentError
        flash.now[:danger] = 'Please ensure all fields are filled in.'
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patients/1
  # PATCH/PUT /patients/1.json
  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to @patient, notice: 'Update Successful!' }
        format.json { render :show, status: :ok, location: @patient }
      else
        format.html { render :edit }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient.destroy
    respond_to do |format|
      format.html { redirect_to patients_url, notice: 'Patient was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_patient
    @patient = Patient.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def patient_params
    params.require(:patient).permit(:first_name, :middle_init, :last_name, :phone, :email, :password)
  end
end
