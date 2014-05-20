require 'spec_helper'

describe LogEntry do
  describe "#previous" do
    before :each do
      @entry_1 = LogEntry.create kms: 122222, for: "B"
      @entry_2 = LogEntry.create kms: 133333, for: "B"
      @entry_3 = LogEntry.create kms: 144444, for: "B"
      @entry_4 = LogEntry.create kms: 155555, for: "B"
      @entry_5 = LogEntry.create kms: 166666, for: "B"
    end
    it "has a getter for the previous log entry based on kms pt. 1" do
      expect(@entry_4.previous).to eq(@entry_3)
    end
    it "has a getter for the previous log entry based on kms pt. 2" do
      expect(@entry_3.previous).to eq(@entry_2)
    end
    it "has a getter for the previous log entry based on kms pt. 2" do
      expect(@entry_2.previous).to eq(@entry_1)
    end
    it "returns nil if it's the first entry" do
      expect(@entry_1.previous).to eq nil
    end
  end
  context "initialization" do
    it "infers the km based on the previous entry, when incomplete reading given" do
      LogEntry.create kms: 123456, for: "B"
      expect(LogEntry.create(kms: 789, for: "B").kms).to eq 123789
    end
    it "infers the km based on the previous entry, when incomplete reading given" do
      LogEntry.create kms: 123456, for: "B"
      expect(LogEntry.create(kms: 89, for: "B").kms).to eq 123489
    end
    it "does not infer anything if a 6 digit number is given" do
      expect(LogEntry.create(kms: 123456, for: "B").kms).to eq 123456
    end
  end
  context "validation" do
    it "requires kms" do
      expect(LogEntry.new(kms: nil, for: "B")).to_not be_valid
    end
    it "limits kms length" do
      expect(LogEntry.new(kms: 1234567, for: "B")).to_not be_valid
    end
    it "ensures kms inputted are the biggest" do
      LogEntry.create kms: 123456, for: "B"
      expect(LogEntry.new(kms: 123455, for: "b")).to_not be_valid
    end
    it "requires a 'for'" do
      expect(LogEntry.new(kms: 1, for: nil)).to_not be_valid
    end
  end
end
