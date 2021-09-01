# frozen_string_literal: true

class AppointmentsController < ApplicationController
  def new
    @appointment = Appointment.new
    @patient = Patient.find(params[:patient_id])
    @preset = @patient.locations.where(home: true).first unless @patient.locations.where(home: true).empty?
  end

  def create
    patient = Patient.find(params[:appointment][:patient_id])
    l = if params.key?('loc-select-to')
          patient.locations.find(params['loc-select-to'])
        else
          patient.locations.find(params['loc-select-from'])
        end
    location_hash = { name: l.name, addr1: l.addr1, addr2: l.addr2, city: l.city, state: l.state, zip: l.zip }
    appt_params = appointment_params
    appt_params['datetime'] = "#{params[:appointment]['dt(1i)']}-#{params[:appointment]['dt(2i)']}-#{params[:appointment]['dt(3i)']} #{params[:appointment]['dt(4i)']}:#{params[:appointment]['dt(5i)']}"
    if appt_params[:locations_attributes]['0'][:name] == 'tmp'
      appt_params[:locations_attributes]['0'].merge! location_hash
    else
      appt_params[:locations_attributes]['1'].merge! location_hash
    end
    logger.debug "appt_params hash: #{appt_params}"
    @appointment = Appointment.new(appt_params)

    respond_to do |format|
      if @appointment.save
        # AdminMailer.with(patient: @patient).new_patient_email.deliver
        flash[:info] = 'Appointment was successfully booked!'
        format.html { redirect_to root_url }
      else
        format.html { render :new }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(
      :patient_id,
      :datetime,
      locations_attributes: %i[name addr1 addr2 city state zip]
    )
  end
end
