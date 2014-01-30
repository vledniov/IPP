require 'swt_shoes/spec_helper'

describe Shoes::Swt::TextBlockPainter do
  include_context "swt app"

  let(:opts) { {justify: true, leading: 10, underline: "single"} }
  let(:gui) { double("gui", fitted_layouts: [fitted_layout])}
  let(:dsl) { double("dsl", app: shoes_app, gui: gui,
                     text: "hello world", cursor: nil,
                     opts: opts, element_width: 200, element_height: 180,
                     element_left: 0, element_top: 10, font: "font",
                     font_size: 16, margin_left: 0, margin_top: 0,
                     text_styles: {}, :hidden? => false).as_null_object
            }

  let(:fitted_layout) { double("fitted layout", left: 0, top: 10,
                               draw: nil, layout: text_layout) }
  let(:text_layout) { double("text layout").as_null_object }

  let(:event) { double("event").as_null_object }
  let(:style) { double(:style) }
  let(:blue) { Shoes::Color.new(0, 0, 255) }
  let(:swt_blue) { Shoes::Swt::Color.new(blue).real }

  subject { Shoes::Swt::TextBlockPainter.new(dsl) }

  before :each do
    ::Swt::TextStyle.stub(:new) { style.as_null_object }
  end

  it "draws" do
    expect(fitted_layout).to receive(:draw)
    subject.paintControl(event)
  end

  it "sets justify" do
    expect(text_layout).to receive(:setJustify).with(opts[:justify])
    subject.paintControl(event)
  end

  it "sets spacing" do
    expect(text_layout).to receive(:setSpacing).with(opts[:leading])
    subject.paintControl(event)
  end

  it "sets alignment" do
    expect(text_layout).to receive(:setAlignment).with(anything)
    subject.paintControl(event)
  end

  it "sets text styles" do
    expect(text_layout).to receive(:setStyle).with(anything, anything, anything).at_least(1).times
    subject.paintControl(event)
  end

  context "rise option" do
    it "sets default rise value to nil" do
      expect(style).to receive(:rise=).with(nil)
      subject.paintControl(event)
    end

    it "sets correct rise value" do
      opts[:rise] = 10
      expect(style).to receive(:rise=).with(10)

      subject.paintControl(event)
    end
  end

  context "underline option" do
    it "sets default underline style to none" do
      opts.delete(:underline)

      expect(style).to receive(:underline=).with(false)
      expect(style).to receive(:underlineStyle=).with(nil)

      subject.paintControl(event)
    end

    it "sets correct underline style" do

      expect(style).to receive(:underline=).with(true)
      expect(style).to receive(:underlineStyle=).with(Shoes::Swt::TextStyleFactory::UNDERLINE_STYLES["single"])

      subject.paintControl(event)
    end

    it "sets underline color" do
      opts[:undercolor] = blue

      expect(style).to receive(:underlineColor=).with(swt_blue)

      subject.paintControl(event)
    end

    it "sets default underline color to nil" do
      expect(style).to receive(:underlineColor=).with(nil)

      subject.paintControl(event)
    end
  end

  context "strikethrough option" do
    it "sets default strikethrough to none" do
      expect(style).to receive(:strikeout=).with(false)

      subject.paintControl(event)
    end

    it "sets strikethrough" do
      opts[:strikethrough] = "single"

      expect(style).to receive(:strikeout=).with(true)

      subject.paintControl(event)
    end

    it "sets strikethrough color" do
      opts[:strikecolor] = blue

      expect(style).to receive(:strikeoutColor=).with(swt_blue)

      subject.paintControl(event)
    end

    it "sets default strikethrough color to nil" do
      expect(style).to receive(:strikeoutColor=).with(nil)

      subject.paintControl(event)
    end
  end

  context "font styles" do
    it "sets font style to bold" do
      opts[:weight] = true
      expect(::Swt::Font).to receive(:new).with(anything, anything, anything, ::Swt::SWT::BOLD)
      subject.paintControl(event)
    end

    it "sets font style to italic" do
      opts[:emphasis] = true
      expect(::Swt::Font).to receive(:new).with(anything, anything, anything, ::Swt::SWT::ITALIC)
      subject.paintControl(event)
    end

    it "sets font style to both bold and italic" do
      opts[:weight] = true
      opts[:emphasis] = true
      expect(::Swt::Font).to receive(:new).with(anything, anything, anything, ::Swt::SWT::BOLD | ::Swt::SWT::ITALIC)

      subject.paintControl(event)
    end

    it "sets font style to normal by default" do
      expect(::Swt::Font).to receive(:new).with(anything, anything, anything, ::Swt::SWT::NORMAL)

      subject.paintControl(event)
    end
  end

  context "colors" do
    let(:black) { Shoes::Swt::Color.new(Shoes::COLORS[:black]).real }
    let(:salmon) { Shoes::Swt::Color.new(Shoes::COLORS[:salmon]).real }

    describe "stroke" do
      it "is black by default" do
        expect(::Swt::TextStyle).to receive(:new).with(anything, black, anything)
        subject.paintControl(event)
      end

      it "is set with opts[:stroke]" do
        opts[:stroke] = Shoes::COLORS[:salmon]
        expect(::Swt::TextStyle).to receive(:new).with(anything, salmon, anything)
        subject.paintControl(event)
      end
    end

    describe "fill" do
      it "is nil by default" do
        expect(::Swt::TextStyle).to receive(:new).with(anything, anything, nil)
        subject.paintControl(event)
      end

      it "is set with opts[:fill]" do
        opts[:fill] = Shoes::COLORS[:salmon]
        expect(::Swt::TextStyle).to receive(:new).with(anything, anything, salmon)
        subject.paintControl(event)
      end
    end
  end

  context "with text fragments" do

    let(:black) { ::Swt::Color.new Shoes.display, 0, 0, 0 }
    let(:white) { ::Swt::Color.new Shoes.display, 255, 255, 255 }
    let(:font) { ::Swt::Graphics::Font.new Shoes.display, "Arial", 12, ::Swt::SWT::NORMAL }

    it "creates a text style" do
      pending "creative testing energy"
      expect(::Swt::TextStyle).to receive(:new).exactly(42).times
      subject.paintControl(event)
    end
  end
end
