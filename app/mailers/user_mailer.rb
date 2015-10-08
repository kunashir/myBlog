#coding: utf-8
class UserMailer < ActionMailer::Base
  default from: "robot@roshen48.ru",  'Content-Transfer-Encoding' => '7bit'

  def notification_to_companies(tr, abort_company)
    emails = User.carriers_email(abort_company)
    @transp_text = "Кто-то отказался от заяки: " + tr.area.name + " - " + tr.city.name + " текущая цена: " + tr.cur_sum.to_s
    for email in emails
    	mail(:to => email, :subject => "Открытая заявка").deliver
   	end
  end

  def request_abort(tr)
  	emails = User.manager #where("nmanager = ?", true)
    @msg_txt = "#{Company.find(tr.company).name} запросила отказ, от перевозки: #{tr.area.name}  - #{tr.city.name}, на дату #{tr.date}"
  	for email in emails
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

  def notification_old_company(tr, old_company)
    emails = User.company_email(old_company)
    @msg_txt = "Перевозка: #{tr.area.name}  - #{tr.city.name}, на дату #{tr.date} снова ваша т.к. другая компания отказалась от ставки"
    emails.each do |email|
      mail(:to => email, :subject => "Возврат ставки").deliver
    end
  end

  def test(email)
  	mail(:to => email, :subject => "Тест")
  end

  def reset_password_email(user)
    @user_name = user.name
    @url  = edit_password_reset_url(user.reset_password_token)
    mail(to: user.email, subject: t("mailer.subject.reset_password"))
  end

  def activation_needed_email(user)
    @user = user
    @url  =  activate_url(user.activation_token) # "#{profile_url}/#{user.activation_token}/activate"
    mail(:to => user.email,
         :subject => t("mailer.subject.confirm_email"))
  end

  def new_user_registered(user)
    @user = user
    admin_emails = User.admins.pluck(:email)
    mail(to: admin_emails, subject: t("mailer.subject.new_user_registered"))
  end
end
