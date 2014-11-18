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

    it "be true when path looks like allowed path" do
      %w[janusz.xml lukasz.rss wykop.json].each do |asset|
        request = double "Request", path: asset
        bv = RackPassword::BlockValidator.new(options, request)
        expect(bv.valid_path?).to be(true)
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
end
