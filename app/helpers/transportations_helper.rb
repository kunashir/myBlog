module TransportationsHelper

	def trad_start_time
	   return  Time.parse(MyBlog::Application.config.time_start)
	end

    def trad_duration
       return MyBlog::Application.config.duration.to_i #in seconds
    end
    
    def trad_stop_time
	   return Time.parse(MyBlog::Application.config.time_stop)
    end

    def require_confirmation?
        if Time.zone.now.localtime.hour >= 17
            return true
        end
        return false
    end

    def percent_spec_price
	  return 10
	end

    def last_moment
        cur_time = 300
        IO.foreach(Rails.root.join('today_random')){|line| cur_time += line.to_i } 
        return    cur_time
    end

    def is_last_moment?
        if Time.zone.now.localtime.min >= (trad_stop_time - last_moment)
            return true
        end
        return false
    end
    
    def check_time
        #-1 если еще рано
        #0 если можно торговатся
        #1 если уже закрылись
        hour    = trad_start_time.hour
        min     = trad_start_time.min + trad_duration
        cur_time    =   Time.zone.now.localtime
        if cur_time < trad_start_time
            return -1
        elsif (trad_start_time <= cur_time) and (cur_time < trad_stop_time)
            return 0
	    end
        return 1
        
    end

    def upper_limit
        return 1.15
    end

end
