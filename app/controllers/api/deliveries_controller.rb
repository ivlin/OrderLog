module Api
  class Api::DeliveriesController < Api::BaseController

    before_action :load_delivery, only: [:create, :show, :destroy, :update]

    def create
      if params[:find]
        @datum= Delivery.find_by(delivery_number: params[:delivery_number])
        if request.referer == deliveries_url
          redirect_to delivery_path(@datum.id)
        end
      else
        @datum = Delivery.find_or_initialize_by(id: params[:id])
        @datum.update_attributes(delivery_params)
        @datum.save
      end
    end

    def update
      @datum.update_attributes(delivery_params)
      @datum.save
    end

    def destroy
      @datum.destroy
    end

    def show
      if @datum.nil?
        render json: { message: "delivery not found", status: :not_found }
      else
        render json: @datum.to_json
      end
    end

    private
    def delivery_params
      params.permit(Delivery.column_names)
    end

    def load_delivery
      @datum = Delivery.find_by(id: params[:id])
    end
  end
end