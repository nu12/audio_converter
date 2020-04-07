class ConvertUpdaterJob < ApplicationJob
  queue_as :default

  def perform(user_id, data)
    ActionCable.server.broadcast "convert_#{user_id}", data
  end
end
