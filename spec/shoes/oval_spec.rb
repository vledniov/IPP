require 'shoes/spec_helper'

describe Shoes::Oval do
  include_context "dsl app"

  let(:left) { 20 }
  let(:top) { 30 }
  let(:width) { 100 }
  let(:height) { 200 }

  describe "basic" do
    subject { Shoes::Oval.new(app, parent, left, top, width, height) }
    it_behaves_like "object with stroke"
    it_behaves_like "object with fill"
    it_behaves_like "object with dimensions"
    it_behaves_like "movable object"
    it_behaves_like "left, top as center"
    it_behaves_like 'object with parent'
  end
end
