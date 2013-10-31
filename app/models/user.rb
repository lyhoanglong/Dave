class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email, :type => String, :default => ""
  field :name, :type => String
  field :phone, :type => String
  field :verification_status, :type => String, :default => nil ## 'waiting','verified'
  field :type, :type => Integer, :default => 'normal' ## {normal ...}

  field :postal_code, :type => String, :default => nil
  field :city, :type => String, :default => nil
  field :country, :type => String, :default => "Vietnam"

  field :sex, :type => String, :default => 'man' # man, woman, unknown
  field :birthday, :type => Date, :default => nil
  field :language, :type => String, :default => "en"

  field :address, :type => String, :default => nil
  field :apn_token, :type => String, :default => nil

  field :created_date, type: DateTime, default: DateTime.current
  field :updated_date, type: DateTime, default: DateTime.current

  field :encrypted_password, :type => String, :default => ""

  #field :avatar, :type => String, :default => nil
  #field :note, :type => String, :default => nil
  #field :facebook_id, :type => String, :default => nil
  #billing_cycle
  #billing_cycle_start_date
  #is_profile_complete

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
  # field :authentication_token, :type => String
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  ## use email to login
  validates :email, :presence => true, :format => {:with => VALID_EMAIL_REGEX},  :if => Proc.new { |user| not user.email.nil? }

  ## user phone to manual call to verify legitimate
  validates :phone, :presence => true, :uniqueness => true, :length => {:minimum => 9, :maximum => 16}, :numericality => {:only_integer => true}
  validates :name, :presence => true, :length => {:minimum => 1, :maximum => 50}
  validates :apn_token, :length => {:is => 64}, :allow_blank => true
  validates :password, :length => {:minimum => 6}, :confirmation => true

  validates :type, :inclusion => {:in => ['normal', 'windfarm_owner']} ## etc
  validates :verification_status, :inclusion => {:in => ['waiting', 'verified']}
  validates :sex, :inclusion => {:in => ['man', 'woman', 'unknown']}

  ## Custom validation
  validate :forbid_changing_type, :on => :update

  def forbid_changing_type
    errors[:type] = "can not be changed!" if self.type_changed?
  end

end
