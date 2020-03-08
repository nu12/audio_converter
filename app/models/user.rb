class User
	include ActiveModel::Model
    attr_accessor :id, :originals, :converted, :created

    def initialize

    end

    def self.find_or_create session
        user = User.new
    	if session[:audio_converter_session].nil?
            # Set user varialbes
    		user.id = (rand() * 10000).to_i
    		user.originals = []
            user.converted = []
            user.created = true

            # Create Redis entries
            $redis.set("originals[#{user.id}]", user.originals.to_s)
            $redis.set("converted[#{user.id}]", user.converted.to_s)

            # Set expiration
            $redis.expire("originals[#{user.id}]", 1.hours.to_i)
            $redis.expire("converted[#{user.id}]", 1.hours.to_i)
        else
            # Set user varialbes
            user.id = session[:audio_converter_session]
            user.originals =    eval $redis.get("originals[#{user.id}]")
            user.converted =    eval $redis.get("converted[#{user.id}]")
            user.created = false
        end
        return user
    end

    def update
        $redis.set("originals[#{self.id}]", self.originals.to_s)
        $redis.set("converted[#{self.id}]", self.converted.to_s)
    end
end
