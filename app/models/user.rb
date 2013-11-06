=begin
                                                REQUIREMENT


DAVE runs with 2 account types and multiple user types as follows. Each have a different price and billing period. But they all go through the creditcard system DPS.

WIND FARM OWNER (WFO)

A windfarm owner account just manages their own windfarms, can see SP's projects and their status of all their blades.

--User Account Types

    Admin - Original user to signup, can manage all farms and systems, accounts subscriptions, giving access to service providers and which farms they have access to, they also setup WFO Managers as below.

    Manager - A manager user is assigned to specific windfarms so they can only view their own windfarms and wind turbines.

SERVICE PROVIDERS (SP)

Service providers are the account types who work for the WFO to inspect and repair their Wind Turbines (WTG). They submit information to DAVE mainly via the app which they use while inspecting the WTG.

--User Account Types

    Admin - Manages all farms and projects, subscriptions, users etc

    Head Technician - Can manage all farms and users

    Technicians - Can only see the projects which they are assigned to.

------------------------------------------------------------------------------------------------------------------------

— Account subscriptions, please make these prices editable in the super admin interface.

WFO - $599 year for 5 farms, each additional farm is $99 year

SP - $59 Month per user account (billed in year parts)

------------------------------------------------------------------------------------------------------------------------

PAYMENT

Payment can be made via bank deposit and Creditcard.

Additional subscriptions added later create a pro-rate effect.

Multiple year subscriptions create a discount. Please show this exactly to user as in: http://appus.net.nz/snap/V0ZHhf.jpg

---- DPS/Recurring Payments

http://www.paymentexpress.com/Technical_Resources/Ecommerce_NonHosted/PxPost

Using the token system with this you can hold the token and bill someones card everytime they renew or upgrade their account.

http://www.paymentexpress.com/Technical_Resources/Ecommerce_NonHosted/PxPost#Tokenbilling

---- Bank Deposits

Bank deposits will just be orders which are made but payment has not been confirmed, so please just have in the super admin area an orders page where Admin can change an order from Awaiting Payment to Paid

------------------------------------------------------------------------------------------------------------------------

DAVE APPROVED

Everyone account which signs up must be approved manually before accessing the whole system for security issues. The super admin must have a list of accounts which they will need to activate before loggin in.

--------------------------------------

Anyone trying to login with any of these problems will be shown an alert such as: "Payment not confirmed" or "Account not activated"

------------------------------------------------------------------------------------------------------------------------

Registration Process:

    Register

    Plan

    Pay

    Approve

    Login

=end

require 'carrierwave/mongoid'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  ## REFERENCES
  has_many :windfarms


  WINDFARM_OWNER = 'windfarm_owner'
  SERVICE_PROVIDER = 'service_provider'
  SYSTEM_ADMINISTRATOR = 'system_administrator'
  BASIC_USER_FIELDS = %w(first_name last_name company_name city country logo logo_thumb address_number1 address_number2 email type)

  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable

  devise :database_authenticatable, :token_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :authentication_keys => [:email]

  ## Database authenticatable
  field :email, :type => String, :default => ""
  field :first_name, :type => String
  field :last_name, :type => String
  field :company_name, :type => String
  field :phone, :type => String
  field :phone_number_2, :type => String
  field :approval_status, :type => String, :default => 'waiting' ## 'waiting','approved'
  field :type, :type => String#, :default => User::WINDFARM_OWNER ## {service_provider, system_administrator ...}

  field :postal_code, :type => String, :default => nil
  field :city, :type => String, :default => nil
  field :country, :type => String, :default => "United States"

  field :sex, :type => String, :default => 'unknown' # male, female, unknown
  field :birthday, :type => Date, :default => nil
  field :language, :type => String, :default => "en"

  field :address_number_1, :type => String, :default => nil
  field :address_number_2, :type => String, :default => nil
  field :apn_token, :type => String, :default => nil

  field :encrypted_password, :type => String, :default => ""

  #field :avatar, :type => String, :default => nil
  #field :note, :type => String, :default => nil
  #field :facebook_id, :type => String, :default => nil

  field :is_profile_complete, :type => String, :default => 'no' ## {yes, no}
  field :is_verified_email, :type => String, :default => 'no' ## {yes, no}

  field :billing_cycle, :type => String, :default => nil
  field :billing_cycle_start_date, :type => DateTime, :default => nil

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Token authenticatable
  field :authentication_token, :type => String
  field :logo, :type => String, :default => nil

  field :total_extra_users, :type => Integer, :default => 0
  field :total_extra_farms, :type => Integer, :default => 0

  mount_uploader :logo, LogoUploader

  attr_accessible :first_name, :last_name, :authentication_token, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at, :company_name,
                  :address_number_2, :address_number_1, :phone, :phone_number_2, :billing_cycle, :billing_cycle_start_date, :is_profile_complete, :is_verified_email,
                  :city, :country, :postal_code, :logo, :logo_cache, :remove_logo, :type, :approval_status, :total_extra_users, :total_extra_farms


  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })
  index({ type: 1 }, {name: "user_type_index", background: true })
  index({ company_name: 1 }, { name: "user_company_index", background: true })
  index({ billing_cycle: 1 }, { name: "user_billing_cycle_index", background: true })

  ### CALLBACK
  before_save :downcase_email, :ensure_authentication_token
  after_create :send_admin_mail

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  ## use email to login
  validates :email, :presence => true, :uniqueness => true, :format => {:with => VALID_EMAIL_REGEX},  :if => Proc.new { |user| not user.email.nil? }

  ## user phone to manual call to verify legitimate
  validates :phone, :presence => true, :uniqueness => true, :length => {:minimum => 9, :maximum => 16}, \
            :numericality => {:only_integer => true}, :if => Proc.new { |user| user.is_profile_complete == 'yes'}
  validates :phone_number_2, :presence => true, :uniqueness => true, :length => {:minimum => 9, :maximum => 16}, :numericality => {:only_integer => true}, \
            :if => Proc.new { |user| user.is_profile_complete == 'yes'}

  validates :total_extra_users, :presence => true, :numericality => {:only_integer => true}
  validates :total_extra_farms, :presence => true, :numericality => {:only_integer => true}

  validates :first_name, :presence => true
  validates :first_name, :length => {:minimum => 1, :maximum => 20}, :if => Proc.new { |user| user.first_name }

  validates :last_name, :presence => true
  validates :last_name, :length => {:minimum => 1, :maximum => 20}, :if => Proc.new { |user| user.last_name }

  validates :company_name, :presence => true, :length => {:minimum => 1, :maximum => 50}, \
            :if => Proc.new { |user| user.is_profile_complete == 'yes'}

  validates :address_number_1, :presence => true, :length => {:minimum => 1, :maximum => 50}, \
            :if => Proc.new { |user| user.is_profile_complete == 'yes'}
  validates :address_number_2, :presence => true, :length => {:minimum => 1, :maximum => 50}, \
            :if => Proc.new { |user| user.is_profile_complete == 'yes'}

  validates :apn_token, :length => {:is => 64}, :allow_blank => true
  validates :password, :presence => true, :length => {:minimum => 6}, :confirmation => true, :if => Proc.new { |user| user.password }

  validates :type, :inclusion => {:in => [User::SERVICE_PROVIDER, User::WINDFARM_OWNER, User::SYSTEM_ADMINISTRATOR]}, :if => Proc.new { |user| user.type} ## etc
  validates :approval_status, :presence => true, :inclusion => {:in => ['waiting', 'approved']}
  validates :sex, :inclusion => {:in => ['male', 'female', 'unknown']}
  validates :is_profile_complete, :presence => true, :inclusion => {:in => ['yes', 'no']}
  validates :is_verified_email, :presence => true, :inclusion => {:in => ['yes', 'no']}
  validates :billing_cycle, :inclusion => {:in => ['1 year', '2 years', '3 years']}, :if => Proc.new { |user| not user.billing_cycle.nil? }
  validates :billing_cycle_start_date, :presence => true, :if => Proc.new { |user| not user.billing_cycle.nil? }

  validates :postal_code, :presence => true, :if => Proc.new { |user| user.is_profile_complete == 'yes'}
  validates :city, :presence => true, :if => Proc.new { |user| user.is_profile_complete == 'yes'}
  validates :country, :presence => true, :if => Proc.new { |user| user.is_profile_complete == 'yes'}

  validate :only_one_system_administrator
  ## Custom validation
  #validate :forbid_changing_type, :on => :update
  #
  #def forbid_changing_type
  #  errors[:type] = "can not be changed!" if self.type_changed?
  #end

  def as_json(options = {})
    lg, lg_thumb = nil, nil
    unless  logo.nil?
      lg = logo.as_json[:logo]["url"]
      lg_thumb = logo.as_json[:logo][:thumb]["url"]
    end

    super.merge('logo' => lg, 'logo_thumb' => lg_thumb)
  end

  def downcase_email
    self.email = self.email.downcase
  end

  def send_admin_mail
    UserMailer.registration_confirmation(self).deliver
  end

  def only_one_system_administrator
    errors.add(:type, 'Permission denied') if User.where(type: User::SYSTEM_ADMINISTRATOR).count > 1
  end
end
