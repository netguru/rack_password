require 'spec_helper'

module RackPassword
  describe Block do

    describe "success rack response" do
      let(:block){ Block.new("app") }

      it "return 200 status code" do
        expect(block.success_rack_response[0]).to eq 200
      end

      it "return html" do
        expect(block.success_rack_response[2][0]).to include("password")
      end

      it "fills in application name if used as Rails middleware" do
        app_name = 'TestAppName'
        class Rails; end
        allow(Rails).to receive_message_chain(:application, :class, :parent_name) { app_name }
        
        expect(block.success_rack_response[2][0]).to include(app_name)
      end
    end
  end
end
