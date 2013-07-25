require 'spec_helper'

class Model < Collector::BaseModel
  attributes :required1, :required2
  attributes_opt :optional1, :optional2
end

class NestedModel < Collector::BaseModel
  attribute :required
  attribute_opt :optional
end

describe Collector::BaseModel do
  it "reports presence of required attributes" do
    obj = Model.new(required1: true, required2: true)
    obj.should have_required_attributes
    obj.missing_attributes.should be_empty
  end
  it "reports absence of required attributes" do
    obj = Model.new(required1: true, optional1: true, optional2: true)
    obj.should_not have_required_attributes
    obj.missing_attributes.should eq [:required2]
  end
  it "reports absence of required attributes in nested objects" do
    nested = NestedModel.new(optional: true)
    obj = Model.new(required1: true, required2: nested, optional1: nested)
    obj.should_not have_required_attributes
    obj.missing_attributes.should eq [{required2: [:required]}, {optional1: [:required]}]
  end
end