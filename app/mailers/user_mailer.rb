#coding: utf-8
class UserMailer < ActionMailer::Base
  default from: "robot@roshen48.ru",  'Content-Transfer-Encoding' => '7bit'
	
  def notification_to_companies(tr, abort_company)
    emails = User.carriers_email(abort_company)
    for email in emails
    	print email
    	@transp_text = "Кто-то отказался от заяки: " + tr.area.name + " - " + tr.storage.name + " текущая цена: " + tr.cur_sum.to_s
    	mail(:to => email, :subject => "Открытая заявка").deliver
   	end
  end

  def request_abort(tr)
  	emails = User.manager #where("nmanager = ?", true)
  	for email in emails
  		@msg_txt = Company.find(tr.company).name + " запросила отказ, от перевозки: " +  tr.area.name + " - " + tr.storage.name 
  		mail(:to => email.email, :subject => "Запрос отмены").deliver
  	end
  end

  def notificate_manager(tr, old_sum)
    abort_time = Time.now.to_s(:time)
    emails = User.manager
    @msg_txt = Company.find(tr.company).name + " отказалсь от заявки: " + tr.area.name + " - " 
      + tr.storage.name + ". Вермя отказа #{abort_time}, была заявлена сумма  " + old_sum
    emails.each do email
      mail(:to => email.email, :subject => "Отказ от заявки").deliver
    end
    
  end

  def test(email)
  	mail(:to => email, :subject => "Тест")
  end
end
