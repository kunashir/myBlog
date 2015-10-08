# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  company            :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#  nmanager           :boolean
#  company_id         :integer
#  is_block           :boolean         default("t")
#  be_notified        :boolean         default("t")
#  show_reg           :boolean         default("t")
#  login_count        :integer         default("0")
#  role               :string(255)
#  ip                 :string(255)
#  agent              :string(255)
#

class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor   :password
  # attr_accessible :name, :email, :company_id, :password, :password_confirmation, :be_notified, :login_count
  #attr_protected :login_count

  scope :manager, -> {where("manager = ?", true)}

  has_many   :transportations #Пользователь может иметь много заявок на перевозку
  belongs_to :company         #но он может работать только на одну фирму
  has_many   :messages, through: :user_msg
  has_many   :user_msg

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i



  validates :name,    :presence => true, :length =>  { :maximum => 50}, :unless => :use_validate?
  validates :email,   :presence => true, :format =>  { :with => email_regex },
                      :uniqueness => { :case_sensitive => false }, :unless => :use_validate?
  validates :company_id, :presence => true , :unless => :use_validate?
  validates :password,  :presence => true, :confirmation  => true,
                        :length   => { :within => 6..40}, on: :create

 # before_save :encrypt_password

  def inc_login(ip, agent)
    self.login_count = self.login_count + 1
    self.ip = ip
    self.agent = agent
    save_without_callbacks(true)
    self.save
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

  # def has_password?(submitted_password)
  #   encrypted_password == encrypt(submitted_password)
  # end

  def show_reg?
    self.show_reg
  end

  # def self.authenticate(email, submitted_password)
  #   user = find_by_email(email)
  #   return nil  if user.nil?
  #   return user if user.has_password?(submitted_password)
  # end

  # def self.authenticate_with_salt(id, cookie_salt=nil, ip=nil, agent=nil)
  #   user = find_by_id(id)
  #   (user && user.salt == cookie_salt && user.ip == ip && user.agent == agent) ? user : nil
  # end

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
    output_array = []
    User.includes(:company).where("companies.id <> ?", ignore_company)
      .select("email").where("be_notified = ?", true).each{|x| output_array << x.email}
    output_array
  end


  def self.company_email(company=0)
    output_array = []
    User.includes(:company).where("companies.id = ?", company)
      .select("email").where("be_notified = ?", true).each{|x| output_array << x.email}
    output_array
  end

  private
    # def encrypt_password
    #  if !@use_callback
    #     self.salt = make_salt if new_record?
    #     return self.encrypted_password = encrypt(password)
    #  end
    #  return true
    # end

    # def encrypt(string)
    #   secure_hash("#{salt}--#{string}")
    # end

    # def make_salt
    #   secure_hash("#{Time.now.utc}--#{password}")
    # end

    # def secure_hash(string)
    #   Digest::SHA2.hexdigest(string)
    # end

    def use_validate?
      @use_callback
    end
end
