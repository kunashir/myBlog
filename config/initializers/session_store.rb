# Be sure to restart your server when you modify this file.

LogisticTender::Application.config.session_store :cookie_store, key: '_logist_tender_session'

#LogisticTender::Application.config.time_start = "13:30"
# lines = File.readlines("tr.ini")
# for line in lines
# 	data_array = line.split(";")
# 	LogisticTender::Application.config.time_start	= data_array[0]
# 	LogisticTender::Application.config.time_stop	= data_array[1]
# 	LogisticTender::Application.config.duration		= data_array[2]
# 	LogisticTender::Application.config.upper_limit	= data_array[3]
# 	LogisticTender::Application.config.ext_duration	= data_array[4] || 300
# 	LogisticTender::Application.config.specprice	= data_array[5] || 10
# 	LogisticTender::Application.config.ext_stop_time = data_array [6]
# end
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# LogisticTender::Application.config.session_store :active_record_store
