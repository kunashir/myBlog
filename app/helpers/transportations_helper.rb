module TransportationsHelper

	def trad_start_time
	    return "2012-01-01 14:00:00".to_time
	end

    def trad_duration
        return 30 #in minutes
    end

	def require_confirmation?
        if Time.zone.now.localtime.hour >= 17
            return true
        end
        return false
    end

    def percent_spec_price
	  return 15
	end

    def last_moment
        cur_time = 5
        IO.foreach(Rails.root.join('today_random')){|line| cur_time += line.to_i } 
        return    cur_time
    end

    def is_last_moment?
        if Time.zone.now.localtime.min >= (trad_start_time.min + (trad_duration - last_moment))
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
        if cur_time.hour < hour
            return -1
        elsif hour == cur_time.hour
            #если часы равны проверяем минуты
            if cur_time.min  < min
                return 0
            end
        end
        return 1
        
    end

    def upper_limit
        return 1.15
    end

end
