class UserLocationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  protect_from_forgery with: :null_session, only: [:create]

  def create
    latitude = params[:latitude]
    longitude = params[:longitude]

    if latitude.blank? || longitude.blank?
      render json: { error: '位置情報が不正です' }, status: :unprocessable_entity
      return
    end

    begin
      UserLocation.record_location(request, latitude.to_f, longitude.to_f)
      head :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue => e
      Rails.logger.error "位置情報の保存に失敗: #{e.message}"
      render json: { error: 'サーバーエラーが発生しました' }, status: :internal_server_error
    end
  end
end
