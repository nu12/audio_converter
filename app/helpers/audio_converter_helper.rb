module AudioConverterHelper
	# From https://apidock.com/ruby/ERB/Util/url_encode
	def self.url_encode(s)
      s.to_s.b.gsub(/[^a-zA-Z0-9_\-~]/) { |m|
        sprintf("%%%02X", m.unpack1("C"))
      }
    end
end
