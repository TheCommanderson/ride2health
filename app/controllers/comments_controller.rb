# frozen_string_literal: true

class CommentsController < ApplicationController
  def index
    @comments = if params.key?(:patient_id)
                  Comment.where(patient_id: params[:patient_id])
                elsif params.key?(:appointment_id)
                  Comment.where(appointment_id: params[:appointment_id])
                else
                  Comment.all
                end
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    @patient = Patient.find(params[:patient_id]) if params.key?(:patient_id)
    @appointment = Appointment.find(params[:appointment_id]) if params.key?(:appointment_id)
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        flash[:info] = 'Thank you for the feedback.  If we need more info we may reach out directly.'
        format.html { redirect_to root_url }
      else
        format.html { render :new }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:text, :author, :is_report, :patient_id)
  end
end
