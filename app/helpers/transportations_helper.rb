module TransportationsHelper

	def trad_start_time(part=0)
	   # Time.parse(APP_CONFIG["time_start"])
       start_time_list = APP_CONFIG["time_start"].split(",")
       Time.parse("#{Date.today} #{start_time_list[part]}:00")
	end

    def trad_duration
       APP_CONFIG["duration"].to_i #in seconds
    end

    def trad_stop_time(part=0)
       #part - for multi part trade
       # Time.parse(APP_CONFIG["time_stop"])
       stop_time_list = APP_CONFIG["time_stop"].split(",")
       # stop_time_list[part]
       Time.parse("#{Date.today} #{stop_time_list[part]}:00")
    end

    def main_range?(cur_time)
        first_part = (trad_start_time..trad_stop_time)
        second_part = (trad_start_time(1)..trad_stop_time(1))
        p "FIRST: #{first_part}"
        p "SECOND: #{second_part}"
        p "#{first_part.cover?(cur_time)}"
        p "#{second_part.cover?(cur_time)}"
        first_part.cover?(cur_time) || second_part.cover?(cur_time)
    end

    def extra_range?(cur_time, close_time)
        return false if close_time.nil?
        first_part = (trad_stop_time..close_time)
        second_part = (trad_stop_time(1)..close_time)
        first_part.cover?(cur_time) || second_part.cover?(cur_time)
    end

    def require_confirmation?
        Time.zone.now.localtime.hour >= 17
        #     return true
        # end
        # return false
    end

    def percent_spec_price
	  return  APP_CONFIG["specprice"].to_i
	end

    def last_moment
        cur_time = 300
        IO.foreach(Rails.root.join('today_random')){|line| cur_time += line.to_i }
        return    cur_time
    end

    def is_last_moment?
        Time.zone.now.localtime >= (trad_stop_time - last_moment)
        #     return true
        # end
        # return false
    end

    def is_ext_time?(cur_time, end_time)

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

        # hour    = trad_start_time.hour
        # min     = trad_start_time.min + trad_duration
        cur_time    =   Time.zone.now.localtime
        return -1 if cur_time < trad_start_time
        return 0 if main_range?(cur_time)
        return 0 if extra_range?(cur_time, end_time)
     #    if cur_time < trad_start_time
     #        return -1
     #    elsif (trad_start_time <= cur_time) and (cur_time < trad_stop_time)
     #        return 0
	    # end

        #Проверим

        # if is_ext_time?(cur_time, end_time)
        #     return 0;
        # end
        return 1

    end

    def upper_limit
        return APP_CONFIG["upper_limit"].to_d
    end

    def end_ext_time
        #return APP_CONFIG["end_time
        return Time.parse(APP_CONFIG["ext_stop_time"])
    end

    def is_trade?
      cur_time = Time.zone.now.localtime
      # (trad_start_time <= cur_time) and (cur_time <= end_ext_time)
      main_range?(cur_time)
    end

    def was_cancel?(tr)
      tr.abort_company && (tr.company == current_user.company ||(manager? or is_admin?)) && tr.cur_sum
    end
end
