module AudioConverterHelper
	# From https://apidock.com/ruby/ERB/Util/url_encode
	def self.url_encode(s)
      s.to_s.b.gsub(/[^a-zA-Z0-9_\-~]/) { |m|
        sprintf("%%%02X", m.unpack1("C"))
      }
    end

    def self.path(user_id)
    	Rails.root.join("storage", user_id.to_s).to_s
    end

    def self.write_file user_id, audio, sanitized
    	File.open("#{AudioConverterHelper::path("#{user_id}/originals")}/#{sanitized}", 'wb') do |file|
        file.write(audio.read)
      end
    end
    
    def self.convert_all user, format, bitrate
      user.originals.each_index do | i |
        ConvertUpdaterJob.perform_now(user.id, {value: i, max: user.originals.size})
        AudioConverterHelper::convert(user.id, user.originals[i], format, bitrate)
      end
    end

  	def self.convert user_id, audio, format, bitrate
      system("ffmpeg -y -i #{AudioConverterHelper::path(user_id)}/originals/#{audio} -b:a #{bitrate}k #{AudioConverterHelper::path(user_id)}/converted/#{audio.split('.')[0]}.#{format}")
      return "#{audio.split('.')[0]}.#{format}" # Return name of the new file
  	end

    def self.sanitize original
      return original.gsub!(/[\"\'\(\)\s\-\;\,]/,"") || original # gsub! returns nil if no substitutions were performed
    end

end


