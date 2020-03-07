class User
	include ActiveModel::Model
    attr_accessor :id, :originals, :converted

    def initialize id=nil
    	if id.nil?
    		self.id = (rand() * 1000).to_i
    		self.originals = []
            self.converted = []
            $redis.set("originals[#{self.id}]", self.originals.to_s)
            $redis.set("converted[#{self.id}]", self.converted.to_s)
            #$redis.expire("user[#{self.id}]", 2.hours.to_i)
        else
            self.id = id
            self.originals =    eval $redis.get("originals[#{self.id}]")
            self.converted =    eval $redis.get("converted[#{self.id}]")
        end

    end

    def update
        $redis.set("originals[#{self.id}]", self.originals.to_s)
        $redis.set("converted[#{self.id}]", self.converted.to_s)
    end
end
