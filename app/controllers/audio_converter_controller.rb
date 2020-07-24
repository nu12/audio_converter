class AudioConverterController < ApplicationController
  before_action :set_user, :set_application_options
  def index
  end

  def upload
    audios = params[:audios] 
    audios.each do | audio | 
      if @input_formats.include? audio.content_type
        sanitized = AudioConverterHelper::sanitize(audio.original_filename)
        AudioConverterHelper::write_file(@user.id, audio, sanitized)
        @user.originals << sanitized
      end
    end   
    update_and_redirect "Upload complete"
  end

  def convert
    if @form_convert_options.include? params[:format]
      @user.converted = AudioConverterHelper::convert_all(@user, params[:format], params[:bitrate])
      update_and_redirect "Convertion complete"
    else
      update_and_redirect "File format not supported", :danger
    end
  end

  def remove
    @user.originals -= [ CGI::unescape(params[:original]) ]
    @user.converted -= [ CGI::unescape(params[:converted]) ] unless params[:converted].nil?
    update_and_redirect "File removed"
  end

  def download
    file_path = "#{AudioConverterHelper.path(@user.id)}/#{CGI::unescape(params[:audio])}"
    if File.exist?(file_path)
      send_file file_path
    else
      redirect_to root_path
    end  
  end

  private

  def set_user
    @user = User.find_or_create(session)
    session[:audio_converter_session] = @user.id
    unless File.exist?(AudioConverterHelper::path(@user.id))
      FileUtils.mkdir_p(AudioConverterHelper::path(@user.id)) 
      RemoveFilesJob.set(wait: 1.hour).perform_later(@user.id)
    end
  end

  def update_and_redirect message, type = :success
    # Didn't work as after_action callback
    @user.originals.uniq!
    @user.converted.uniq!
    @user.update
    flash[type] = message
    redirect_to root_path
  end

  def set_application_options
    @input_formats = ["audio/mpeg", "audio/x-wav", "audio/wav", "video/mp4"]
    @form_input_formats = 'audio/mp3,audio/wav,video/mp4'
    @form_convert_options = [ "aac", "ogg", "mp3", "wav" ]
    @form_bitrate_options = [ "192", "128", "96" ]
  end

end
