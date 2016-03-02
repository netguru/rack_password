require 'spec_helper'
require 'rack_password'

describe RackPassword::BlockValidator do
  let(:options){ Hash.new }

  describe "valid ip" do
    let(:options) { Hash[ip_whitelist: ["127.0.0.1"]] }
    it "be true when ip is whitelisted" do
      request = double "Request", ip: "127.0.0.1"
      bv = RackPassword::BlockValidator.new(options, request)
      expect(bv.valid_ip?).to be(true)
    end

    it "be false when ip is not whitelisted" do
      request = double "Request", ip: "192.168.0.1"
      bv = RackPassword::BlockValidator.new(options, request)
      expect(bv.valid_ip?).to be(false)
    end
  end

  describe "valid path" do
    it "be true when path is whitelisted" do
      options[:path_whitelist] = /secret\/gate/
      request = double "Request", path: "secret/gate"
      bv = RackPassword::BlockValidator.new(options, request)
      expect(bv.valid_path?).to be(true)
    end

    it "be false when path contains xml/rss/json resource" do
      %w[janusz.xml lukasz.rss wykop.json].each do |asset|
        request = double "Request", path: asset
        bv = RackPassword::BlockValidator.new(options, request)
        expect(bv.valid_path?).to be(false)
      end
    end

    it "be false when path doesn't looks like asset" do
      %w[products orders users].each do |asset|
        request = double "Request", path: asset
        bv = RackPassword::BlockValidator.new(options, request)
        expect(bv.valid_path?).to be(false)
      end
    end
  end

  describe "valid code" do
    let(:options) { Hash[auth_codes: ["secret"], key: :staging_auth] }
    let(:request) { double "Request" }

    it "be true when code is correct" do
      bv = RackPassword::BlockValidator.new(options, request)
      expect(bv.valid_code?("secret")).to be(true)
    end

    it "be false when code is incorrect" do
      bv = RackPassword::BlockValidator.new(options, request)
      expect(bv.valid_code?("incorrect_secret")).to be(false)
    end
  end

  describe "proc control" do
    context "with proc allowing to pass" do
      let(:options) { Hash[auth_codes: ["secret"], key: :staging_auth, custom_rule: proc { true } ] }
      let(:request) { double "Request" }

      it "is true when proc evaluates to true" do
        bv = RackPassword::BlockValidator.new(options, request)
        expect(bv.valid_custom_rule?).to be(true)
      end

      it "is true when proc returns true" do
        bv = RackPassword::BlockValidator.new({custom_rule: proc { return true }}, request)
        expect(bv.valid_custom_rule?).to be(true)
      end
    end

    context "with proc set to deny-all" do
      let(:options) { Hash[auth_codes: ["secret"], key: :staging_auth, custom_rule: proc { false } ] }
      let(:request) { double "Request", path: "/", ip: "127.0.0.1", cookies: { } }

      it "is true when proc evaluates to true" do
        bv = RackPassword::BlockValidator.new(options, request)
        expect(bv.valid_custom_rule?).to be(false)
        expect(bv.valid?).to be(false)
      end

      it "is false when proc returns false" do
        bv = RackPassword::BlockValidator.new({custom_rule: proc { return false }}, request)
        expect(bv.valid_custom_rule?).to be(true)
      end
    end
  end
end
