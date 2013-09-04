# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  company    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :name, :email, :company_id, :password, :password_confirmation, :be_notified, :login_count
  #attr_protected :login_count
  
  has_many   :transportations #Пользователь может иметь много заявок на перевозку
  belongs_to :company         #но он может работать только на одну фирму
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  
  
  validates :name,    :presence => true, :length =>  { :maximum => 50}, :unless => :use_validate?
  validates :email,   :presence => true, :format =>  { :with => email_regex },
                      :uniqueness => { :case_sensitive => false }, :unless => :use_validate?
  validates :company_id, :presence => true , :unless => :use_validate?
  validates :password,  :presence => true, :confirmation  => true,
                        :length   => { :within => 6..40}, :unless => :use_validate?
                        
 before_save :encrypt_password
  
  def inc_login
    self.login_count = self.login_count + 1
    save_without_callbacks(true)
    self.save!
  end

  def dec_login
    if self.login_count > 0
      self.login_count -= 1
      save_without_callbacks(true)
      self.save!
    end
  end

  def was_login?
    self.login_count == 0 ? false : true
  end

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def show_reg?
    self.show_reg
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def save_without_callbacks ( use )
    @use_callback = use
  end
  
  def show_save_type
    if !@use_callback
      return "Use callback"
    end
    return "Callback off"
  end


  def self.carriers_email(ignore_company=0)
      if ignore_company == 0
          users_list = User.all
      else
          users_list = User.where("company_id != ? AND be_notified = ?", ignore_company, true)
      end
      output_array = Array.new
      j = 0
      for i in users_list
          if i.company.is_freighter
              output_array[j] = i.email
              j = j + 1
          end
      end
      output_array
  end

  private
    def encrypt_password
     if !@use_callback
        self.salt = make_salt if new_record?
        return self.encrypted_password = encrypt(password)
     end
     return true
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

    def use_validate?
      @use_callback
    end
end
