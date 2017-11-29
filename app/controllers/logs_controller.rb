class LogsController < ApplicationController
  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def log_params
    params.require(:log).permit(:user_id, :action, :content)
  end
end