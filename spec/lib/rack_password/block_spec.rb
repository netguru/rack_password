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

        context 'and when "force_cookie_root_path" not used' do
          it 'does not set root path for the cookie' do
            expect(block.call(request)[1]['Set-Cookie']).to_not include('path=/')
          end
        end

        context 'and when "force_cookie_root_path" used' do
          let(:block) do
            Block.new('app', { auth_codes: ['Janusz'], force_cookie_root_path: true })
          end

          it 'sets root path for the cookie' do
            expect(block.call(request)[1]['Set-Cookie']).to include('path=/')
          end
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
