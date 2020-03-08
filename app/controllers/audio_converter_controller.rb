class AudioConverterController < ApplicationController
  before_action :set_user
  def index
  end

  def upload
    audios = params[:audios] 
    audios.each do | audio | 
      if audio.content_type == 'audio/mpeg'
        sanitized = AudioConverterHelper::sanitize(audio.original_filename)
        AudioConverterHelper::write_file(@user.id, audio, sanitized)
        @user.originals << sanitized
      end
    end   
    update_and_redirect "Upload complete"
  end

  def convert
    @user.converted = []
    @user.originals.each do | audio |
      AudioConverterHelper::convert(@user.id, audio, params[:format], params[:bitrate])
      @user.converted << "#{audio.split('.')[0]}.#{params[:format]}"
    end
    update_and_redirect "Convertion complete"
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

  def update_and_redirect message
    # Didn't work as after_action callback
    @user.originals.uniq!
    @user.converted.uniq!
    @user.update
    flash[:alert] = message
    redirect_to root_path
  end

end
