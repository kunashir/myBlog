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
	  return  MyBlog::Application.config.specprice.to_i
	end

    def last_moment
        cur_time = 300
        IO.foreach(Rails.root.join('today_random')){|line| cur_time += line.to_i } 
        return    cur_time
    end

    def is_last_moment?
        if Time.zone.now.localtime >= (trad_stop_time - last_moment)
            return true
        end
        return false
    end

    def is_ext_time?(cur_time, end_time)
        puts "ext_time cur_time" + cur_time.to_s
        puts "ext_time end_time" + end_time.to_s
        if end_time.nil?
            return false
        end
        if (end_time < trad_stop_time)
            return false
        end
        if (end_ext_time <= cur_time )
            return false
        end
        if (cur_time < end_time)
            return true
        end

        return false
    end

    def show_close_time(time_last_edit)
        if (time_last_edit.nil?) or (time_last_edit.to_s.empty?)
            return ""
        end
        puts ("TIME=>" + time_last_edit.to_s)
        cur_time    =   Time.zone.now.localtime
        if (trad_start_time <= cur_time) and (cur_time < end_ext_time)
            return time_last_edit.to_s(:time)
        end
        return "";
    end
    
    def check_time(end_time = nil)
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

        #Проверим 
        
        if is_ext_time?(cur_time, end_time)
            return 0;
        end
        return 1
        
    end

    def upper_limit
        return MyBlog::Application.config.upper_limit.to_i
    end

    def end_ext_time
        #return MyBlog::Application.config.end_time
        return Time.parse(MyBlog::Application.config.ext_stop_time)
    end

    
end
