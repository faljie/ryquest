# frozen_string_literal: true

RSpec.describe 'Ryquest context', type: :request do
  describe '#response!' do
    subject { response! }

    context 'with invalid request' do
      describe 'INVALID /path' do
        it 'should return response' do
          expect(self).to receive(:response).and_return nil
          expect(self).to receive(:response).and_return :response
          expect(self).not_to receive(:invalid)

          expect(subject).to eq :response
        end
      end
    end

    context 'with valid http verbs' do
      before :each do
        allow(self).to receive(:response).and_return nil
      end

      describe 'GET /path' do
        it 'should call get' do
          expect(self).to receive(:get).with '/path', headers: nil, params: nil

          subject
        end
      end

      describe 'POST /path' do
        it 'should call post and convert body to json' do
          expect(self).to receive(:post).with '/path', headers: nil, params: nil

          subject
        end
      end

      describe 'PATCH /path' do
        it 'should call patch' do
          expect(self).to receive(:patch).with '/path', headers: nil, params: nil

          subject
        end
      end

      describe 'PUT /path' do
        it 'should call put' do
          expect(self).to receive(:put).with '/path', headers: nil, params: nil

          subject
        end
      end

      describe 'DELETE /path' do
        it 'should call delete' do
          expect(self).to receive(:delete).with '/path', headers: nil, params: nil

          subject
        end
      end
    end

    context 'with valid request' do
      before(:each) { allow(self).to receive(:response).and_return nil }

      describe 'GET /path' do
        context 'in sub example group' do
          it 'should dig to find the request' do
            expect(self).to receive(:get)

            subject
          end
        end

        context 'with multiple parents request' do
          describe 'POST /path' do
            it 'should stop dig at the first valid request' do
              expect(self).not_to receive(:get)
              expect(self).to receive(:post)

              subject
            end
          end
        end

        context 'when response have not result' do
          it 'should launch the request and return the result' do
            expect(self).to receive(:response).and_return nil
            expect(self).to receive(:response).and_return :response
            expect(self).to receive(:get)

            expect(subject).to eq :response
          end
        end

        context 'when response already have a result' do
          it 'should return response cached value instead launch the request' do
            allow(self).to receive(:response).and_return :response

            expect(self).not_to receive :get
            expect(subject).to eq :response
          end
        end

        context 'with headers and params' do
          let(:headers) { { key: :value } }
          let(:params) { { key: :value } }

          it 'should request with the extra headers and params' do
            expect(self).to receive(:get).with '/path', headers: headers, params: params

            subject
          end
        end

        context 'with path params' do
          let(:param1) { 1 }
          let(:param2) { 2 }

          describe 'GET /path/:param1/:param2' do
            it 'should replace path params by it value' do
              expect(self).to receive(:get).with '/path/1/2', headers: nil, params: nil

              subject
            end

            context 'when path params respond to id' do
              let(:param1) { double 'param1', id: 1 }
              let(:param2) { double 'param2', id: 2 }

              it 'should replace path params by their id value' do
                expect(self).to receive(:get).with '/path/1/2', headers: nil, params: nil

                subject
              end
            end
          end
        end
      end
    end
  end

  describe '#json!' do
    before :each do
      allow(self).to receive(:response!).and_return double(body: '{"json":true}')
    end

    it 'should parse response! body as json' do
      expect(json!).to eq 'json' => true
    end
  end
end
