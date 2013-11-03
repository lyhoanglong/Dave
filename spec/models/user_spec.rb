require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :first_name => "Example",
      :last_name => "User",
      :email => "user@example.com"
    }
  end

  describe 'first name' do
    it 'blank first name' do
      User.new(@attr.merge(:first_name => "")).should_not be_valid
    end

    it 'too long first name' do
      User.new(@attr.merge(:first_name => 'a'*21)).should_not be_valid
    end
  end

  describe 'last name' do
    it 'blank last name' do
      User.new(@attr.merge(:last_name => "")).should_not be_valid
    end

    it 'too long last name' do
      User.new(@attr.merge(:last_name => 'a'*21)).should_not be_valid
    end

  end

  describe "should create a new instance given a valid attribute" do
    before do
      @user = User.create!(@attr)
    end

    subject { @user }

    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:company_name) }

    it { should respond_to(:address_number_1) }
    it { should respond_to(:address_number_2) }
    it { should respond_to(:country) }
    it { should respond_to(:city) }
    it { should respond_to(:postal_code) }

    it { should respond_to(:type) }
    it { should respond_to(:language) }
    it { should respond_to(:email) }
    it { should respond_to(:phone) }
    it { should respond_to(:phone_number_2) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:verification_status) }

    it { should respond_to(:billing_cycle) }
    it { should respond_to(:billing_cycle_start_date) }
    it { should respond_to(:is_profile_complete) }
    it { should respond_to(:is_verified_email) }

    it { should respond_to(:authentication_token) }
    it { should respond_to(:reset_password_token) }
    it { should respond_to(:reset_password_sent_at) }
    it { should respond_to(:sign_in_count) }
    it { should respond_to(:current_sign_in_at) }
    it { should respond_to(:last_sign_in_at) }

    it {should be_valid}
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should auto downcase email address" do
    u = User.create!({ :first_name => "Example", :last_name => "User", :email => "USer@cnc.vn"})
    u.email.should eql('user@cnc.vn')
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password => "aaaaaaaaaa", :password_confirmation => "bababababa")).should_not be_valid
    end

    it "should reject short passwords" do
      User.new(@attr.merge(:password => "12345", :password_confirmation => "12345")).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr.merge(:password => "123456", :password_confirmation => "123456"))
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end

  describe 'after verifying email' do
    before do
      @user = User.new(
        @attr.merge({
          :is_verified_email => 'yes',
          :company_name => 'Colin Corp',
          :phone => '841689287707',
          :phone_number_2 => '841689287707',
          :postal_code => '100000',
          :city => 'hanoi',
          :country => 'Vietnam',
          :address_number_1 => 'hanoi',
          :address_number_2 => 'Vietnam',
          :billing_cycle => '1 year',
          :billing_cycle_start_date => DateTime.current
        })
      )
    end

    describe 'company name' do
      it 'blank company name' do
        @user.company_name = ''
        @user.should_not be_valid
      end

      it 'too long company name' do
        @user.company_name = 'a'*51
        @user.should_not be_valid
      end
    end

    it "is_verified_email" do
      @user.is_verified_email = 'invalid'
      @user.should_not be_valid
    end

    describe "phone" do
      it 'phone is blank' do
        @user.phone = ''
        @user.should_not be_valid
      end

      it 'phone is too short' do
        @user.phone = '123'
        @user.should_not be_valid
      end

      it 'phone is too long' do
        @user.phone = '123456789123456789'
        @user.should_not be_valid
      end

      it 'phone has verbal characters' do
        @user.phone = '123456789a'
        @user.should_not be_valid
      end
    end

    describe "phone number 2" do
      it 'phone_number_2 is blank' do
        @user.phone_number_2 = ''
        @user.should_not be_valid
      end

      it 'phone_number_2 is too short' do
        @user.phone_number_2 = '123'
        @user.should_not be_valid
      end

      it 'phone_number_2 is too long' do
        @user.phone_number_2 = '123456789123456789'
        @user.should_not be_valid
      end

      it 'phone_number_2 has verbal characters' do
        @user.phone_number_2 = '123456789a'
        @user.should_not be_valid
      end
    end

    describe 'postal code' do
      it 'postal_code is blank' do
        @user.postal_code = ''
        @user.should_not be_valid
      end
    end

    describe 'city' do
      it 'city is blank' do
        @user.city = ''
        @user.should_not be_valid
      end
    end

    describe 'country' do
      it 'country is blank' do
        @user.country = ''
        @user.should_not be_valid
      end
    end

    describe 'billing_cycle_start_date' do
      it 'billing_cycle_start_date is blank' do
        @user.billing_cycle_start_date = ''
        @user.should_not be_valid
      end
    end

    describe 'billing_cycle' do
      it 'invalid option' do
        @user.billing_cycle = '5 years'
        @user.should_not be_valid
      end
    end

    describe 'address_number_1' do
      it 'blank address_number_1' do
        @user.address_number_1 = ''
        @user.should_not be_valid
      end

      it 'too long address_number_1' do
        @user.address_number_1 = 'a'*51
        @user.should_not be_valid
      end
    end

    describe 'address_number_2' do
      it 'blank address_number_2' do
        @user.address_number_2 = ''
        @user.should_not be_valid
      end

      it 'too long address_number_2' do
        @user.address_number_2 = 'a'*51
        @user.should_not be_valid
      end
    end

  end

end
