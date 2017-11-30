class StatsController < ApplicationController
  private
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def stat_params
      params.require(:stat).permit(:total_deleted_users, :total_deleted_rentals, :total_deleted_cars)
    end
end
