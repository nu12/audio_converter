class WelcomeController < ApplicationController
  def index
  	@user = set_user
    path = Rails.root.join("public", @user.id.to_s).to_s
    FileUtils.mkdir_p(path) unless File.exist?(path)
  end

  def upload
    @user = set_user
    audios = params[:audios] 
    audios.each do |audio| 
      File.open(Rails.root.join("public", "#{@user.id}", audio.original_filename), 'wb') do |file|
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
    @user = set_user
    format = params[:format] 
    path = Rails.root.join("public", @user.id.to_s).to_s
    @user.converted = []
    @user.originals.each do | audio |
      system("ffmpeg -y -i #{path}/#{audio} -b:a 128k #{path}/#{audio.split('.')[0]}.#{format}")
      @user.converted << "#{audio.split('.')[0]}.#{format}"
    end
    @user.converted.uniq!
    @user.update
    flash[:alert] = "Convertion complete!"
    redirect_to root_path 
  end

  private

  def set_user
  	if session[:audio_converter_session].nil?
  		u = User.new
  		session[:audio_converter_session] = u.id
  	else
  		u = User.new session[:audio_converter_session].to_i
  	end
  	return u
  end

end
