class AudioConverterController < ApplicationController
  before_action :set_user
  def index
  end

  def upload
    audios = params[:audios] 
    audios.each do |audio| 
      File.open("#{AudioConverterHelper::path(@user.id)}/#{audio.original_filename}", 'wb') do |file|
        @user.originals << audio.original_filename
        file.write(audio.read)
      end
    end   
    @user.originals.uniq!
    @user.update
    flash[:alert] = "Upload complete!"
    redirect_to root_path 
  end

  def convert
    format = params[:format]
    bitrate = params[:bitrate]
    @user.converted = []
    @user.originals.each do | audio |
      system("ffmpeg -y -i #{AudioConverterHelper::path(@user.id)}/#{audio} -b:a #{bitrate}k #{AudioConverterHelper::path(@user.id)}/#{audio.split('.')[0]}.#{format}")
      @user.converted << "#{audio.split('.')[0]}.#{format}"
    end
    @user.converted.uniq!
    @user.update
    flash[:alert] = "Convertion complete!"
    redirect_to root_path 
  end

  def remove
    original = CGI::unescape(params[:original] )
    converted = CGI::unescape(params[:converted] ) unless params[:converted].nil?
    @user.originals -= [ original ]
    @user.converted -= [ converted ] unless params[:converted].nil?
    @user.update
    flash[:alert] = "File removed!"
    redirect_to root_path 
  end

  private

  def set_user
  	@user = User.find_or_create(session)
    set_new_user if @user.created
  end

  def set_new_user
    session[:audio_converter_session] = @user.id
    session[:expires_at] = Time.current + 1.hour    
    FileUtils.mkdir_p(AudioConverterHelper::path(@user.id)) unless File.exist?(AudioConverterHelper::path(@user.id))
  end

end
