#coding: utf-8
class UserMailer < ActionMailer::Base
  default from: "robot@roshen48.ru"

  def notification_to_companies(tr, abort_company)
    emails = User.carriers_email(abort_company)
    for email in emails
    	print email
    	@transp_text = "Кто-то отказался от заяки: " + tr.storage_source + " - " + tr.storage.name + " текущая цена: " + tr.cur_sum.to_s
    	mail(:to => email, :subject => "Открытая заявка").deliver
   	end

  end

  def request_abort(tr)
  	emails = User.where("nmanager = ?", true)
  	for email in emails
  		@msg_txt = Company.find(tr.company).name + " запросила отказ, от перевозки: " +  tr.storage_source + " - " + tr.storage.name 
  		mail(:to => email.email, :subject => "Запрос отмены").deliver
  	end
  end

  def test(email)
  	mail(:to => email, :subject => "Тест")
  end
end
