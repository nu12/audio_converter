class ConvertChannel < ApplicationCable::Channel
  def subscribed
    stream_from "convert_#{params[:user]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
