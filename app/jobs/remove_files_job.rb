class RemoveFilesJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    FileUtils.rm_rf(AudioConverterHelper::path(user_id)) if File.exist?(AudioConverterHelper::path(user_id))
  end
end
