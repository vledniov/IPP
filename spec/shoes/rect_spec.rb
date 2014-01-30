require 'shoes/spec_helper'

shared_examples_for "basic rect" do
  it "retains app" do
    expect(rect.app).to eq(app)
  end

  it "creates gui object" do
    expect(rect.gui).not_to be_nil
  end
end

describe Shoes::Rect do
  include_context "dsl app"

  let(:parent) { app }
  let(:left) { 44 }
  let(:top) { 66 }
  let(:width) { 111 }
  let(:height) { 333 }
  subject(:rect) { Shoes::Rect.new(app, parent, left, top, width, height) }

  it_behaves_like "basic rect"
  it_behaves_like "object with fill"
  it_behaves_like "object with stroke"
  it_behaves_like "object with style"
  it_behaves_like "object with dimensions"
  it_behaves_like "movable object"
  it_behaves_like "left, top as center"
  it_behaves_like 'object with parent'
end
