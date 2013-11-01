require 'spec_helper'

class Model < ActiveRecord::Base
  extend Enumerate::Model

  enumerate :status, [:available, :canceled, :completed]
end

class OtherModel < ActiveRecord::Base
  extend Enumerate::Model

  belongs_to :model

  enumerate :status, [:active, :expired, :not_expired]
end

class ModelAllowingNil < ActiveRecord::Base
  self.table_name = 'models'

  extend Enumerate::Model

  belongs_to :model

  enumerate :status, [:active, :expired, :not_expired], :allow_nil => true
end


describe :Enumerate do

  before(:each) do
    Model.delete_all
    OtherModel.delete_all

    @obj = Model.create!(:status => :available)
    @canceled_obj = Model.create!(:status => :canceled)
    @completed_obj = Model.create!(:status => :completed)

    @active_obj = OtherModel.create!(:status => :active, :model => @obj)
    @expired_obj = OtherModel.create!(:status => :expired, :model => @canceled_obj)
    @not_expired_obj = OtherModel.create!(:status => :not_expired, :model => @canceled_obj)
  end

  describe "allow nil" do

    before(:each) do
      @obj_not_allowing_nil = Model.create
      @obj_allowing_nil = ModelAllowingNil.create
    end

    describe "model allowing enum value to be nil" do
      it "should be valid" do
        @obj_allowing_nil.should be_valid
      end

    end

    describe "model not allowing enum value to be nil" do
      it "should be invalid" do
        @obj_not_allowing_nil.should be_invalid
      end
    end

  end

  describe "short hand methods" do
    describe "question mark (?)" do
      it "should return true if value of enum equals a value" do
        @obj.available?.should be_true
      end

      it "should return false if value of enum is different " do
        @obj.canceled?.should be_false
      end

    end

    describe "exclemation mark (!)" do
      it "should change the value of the enum to the methods value" do
        @obj.canceled!
        @obj.status.should == :canceled
      end
    end

    it "should have two shorthand methods for each possible value" do
      Model::STATUSES.each do |key, val|
        @obj.respond_to?("#{key}?").should be_true
        @obj.respond_to?("#{key}!").should be_true
      end
    end
  end

  describe "getting value" do
    it "should always return the enums value as a symbol" do
      @obj.status.should == :available
      @obj.status = "canceled"
      @obj.status.should == :canceled
    end

  end

  describe "setting value" do
    it "should except values as symbol" do
      @obj.status = :canceled
      @obj.canceled?.should be_true
    end

    it "should except values as string" do
      @obj.status = "canceled"
      @obj.canceled?.should be_true
    end
  end

  describe "validations" do
    it "should not except a value outside the given list" do
      @obj = Model.new(:status => :available)
      @obj.status = :foobar
      @obj.should_not be_valid
    end

    it "should except value in the list" do
      @obj = Model.new(:status => :available)
      @obj.status = :canceled
      @obj.should be_valid
    end
  end

  describe "scopes" do
    it "should return objects with given value" do
      Model.available.should == [@obj]
      Model.canceled.should == [@canceled_obj]
    end

    it "should return objects with given value when joined with models who have the same enum field" do
      OtherModel.joins(:model).active.should == [@active_obj]
    end

  end


  it "class should have a CONST that holds all the available options of the enum" do
    Model::STATUSES.should include(:available, :canceled, :completed)
  end

end