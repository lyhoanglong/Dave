require 'spec_helper'

describe 'Windfarm' do
  before(:each) do
    @attr = {
        :name => "Test WindFarm",
        :iec => "1A",
        :roughness => 'Cities, forest',
        :location_type => 'Hot'
    }

    @windfarm = Windfarm.create!(@attr)

  end

  subject { @windfarm }

  it { should respond_to(:name) }
  it { should respond_to(:iec) }
  it { should respond_to(:roughness) }

  it { should respond_to(:location_type) }

  it { should respond_to(:power) }
  it { should respond_to(:total_turbines) }
  it { should respond_to(:geo_loc) }
  it { should respond_to(:date_commissioned) }

  it { should respond_to(:location) }

  it { should respond_to(:dave_active) }
  it { should respond_to(:dave_approved) }
  it { should respond_to(:auto_activate) }

  it {should be_valid}

  describe 'name' do
    it 'blank name' do
      User.new(@attr.merge(:name => "")).should_not be_valid
    end

    it 'too long name' do
      User.new(@attr.merge(:name => 'a'*201)).should_not be_valid
    end
  end

  describe 'location' do
    it 'too long name' do
      User.new(@attr.merge(:name => 'a'*201)).should_not be_valid
    end
  end

  describe 'system field' do
    describe 'invalid' do
      it "dave_active" do
        @windfarm.dave_active = 'invalid'
        @windfarm.should_not be_valid
      end

      it "dave_approved" do
        @windfarm.dave_approved = 'invalid'
        @windfarm.should_not be_valid
      end

      it "auto_activate" do
        @windfarm.auto_activate = 'invalid'
        @windfarm.should_not be_valid
      end
    end

    describe 'valid' do
      it 'yes, no' do
        ['yes', 'no'].each do |v|
          @windfarm.dave_active = v
          @windfarm.dave_approved = v
          @windfarm.auto_activate = v

          @windfarm.should be_valid
        end
      end
    end
  end

  describe 'iec' do
    it 'valid' do
      ['1A','2A','3A','1B','2B','3B','1C','2C','3C','S'].each do |v|
        @windfarm.iec = v
        @windfarm.should be_valid
      end
    end

    it 'invalid' do
      ['invalid', '1122a'].each do |v|
        @windfarm.iec = v
        @windfarm.should_not be_valid
      end
    end

  end

  describe 'total turbines' do
    it 'valid' do
      [1,2,100].each do |v|
        @windfarm.total_turbines = v
        @windfarm.should be_valid
      end
    end

    it 'invalid' do
      ['2a', '10a'].each do |v|
        @windfarm.total_turbines = v
        @windfarm.should_not be_valid
      end
    end
  end

  ##TODO: :geo_loc, :date_commissioned, :roughness,:location_type
end
