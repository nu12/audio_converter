class ConvertUpdaterJob < ApplicationJob
  queue_as :default

  def perform(user_id, index)
    ActionCable.server.broadcast "convert_#{user_id}", {index: index}
  end
end
