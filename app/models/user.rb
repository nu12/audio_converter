class User
	include ActiveModel::Model
    attr_accessor :id

    def initialize
    end

    def self.find_or_create session
        user = User.new
        if session[:audio_converter_session].nil?
            user.id = (rand() * 10000).to_i
        else
            user.id = session[:audio_converter_session]
        end
        return user
    end

    def originals
        Dir[ "./storage/#{id}/originals/*" ].select { | f | File.file? f }.map{ | f | f.split("/").last }.sort!
    end

    def converted
        Dir[ "./storage/#{id}/converted/*" ].select { | f | File.file? f }.map{ | f | f.split("/").last }.sort!
    end
    
end
