require 'spec_helper'

module RackPassword
  describe Block do
    let(:app_name) { 'TestAppName' }

    before do
      class Rails; end
      allow(Rails).to receive_message_chain(:application, :class, :parent_name) { app_name }
      allow(Rack::Request).to receive(:new).and_return(request)
    end

    describe 'for not post requests' do
      let(:block) { Block.new('app', auth_codes: ['Janusz']) }
      let(:request) do
        double(
          cookies: {},
          host: 'localhost',
          params: { 'code' => 'Janusz' },
          path: '/',
          post?: false
        )
      end

      it 'returns 200 status code' do
        expect(block.call(request)[0]).to eq(200)
      end

      it 'returns html' do
        expect(block.call(request)[2][0]).to include('password')
      end

      it 'fills in application name if used as Rails middleware' do
        expect(block.call(request)[2][0]).to include(app_name)
      end
    end

    describe 'for post requests' do
      let(:request) do
        double(
          cookies: {},
          host: 'localhost',
          params: { 'code' => 'Janusz' },
          path: '/',
          post?: true
        )
      end

      context 'when requests contain proper auth code' do
        let(:block) { Block.new('app', { auth_codes: ['Janusz'] }) }

        it 'returns 301 status code' do
          expect(block.call(request)[0]).to eq(301)
        end
      end

      context 'when requests contain invalid auth code' do
        let(:block) { Block.new('app', { auth_codes: ['Janusz123'] }) }

        it 'returns html' do
          expect(block.call(request)[2][0]).to include('password')
        end
      end
    end
  end
end
