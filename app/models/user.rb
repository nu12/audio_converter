class User
	include ActiveModel::Model
    attr_accessor :id, :originals, :converted

    def initialize

    end

    def self.find_or_create session
        user = User.new
		user.originals = []
        user.converted = []
        if session[:audio_converter_session].nil?
            # Set user varialbes
            user.id = (rand() * 10000).to_i
            # Create Redis entries
            $redis.set("originals[#{user.id}]", user.originals.to_s)
            $redis.set("converted[#{user.id}]", user.converted.to_s)
        else
            # Set user varialbes
            user.id = session[:audio_converter_session]
            unless $redis.get("originals[#{user.id}]").nil? && $redis.get("converted[#{user.id}]").nil?
                user.originals = eval $redis.get("originals[#{user.id}]")    
                user.converted = eval $redis.get("converted[#{user.id}]")    
            end 
        end
        # Set expiration
        $redis.expire("originals[#{user.id}]", 1.hour.to_i)
        $redis.expire("converted[#{user.id}]", 1.hour.to_i)
        return user
    end

    def update
        $redis.set("originals[#{self.id}]", self.originals.to_s)
        $redis.set("converted[#{self.id}]", self.converted.to_s)
    end

end
