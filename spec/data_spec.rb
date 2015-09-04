require 'spec_helper'

RSpec.describe '/data' do

  describe 'success' do

    before { get '/data', params, format: :json }

    it 'should return a status of 200' do
      expect(last_response.status).to eq(200)
    end

    it "should return a content-type of 'application/json'" do
      expect(last_response.content_type).to eq('application/json')
    end
  end

  def params
    fields = [
      { field: 'Name' },
      { field: 'FirstName' },
      { field: 'LastName' }
    ]

    {
      user: 1,
      project_id: 1,
      redcap_url: 'http://www.google.com',
      id: '1',
      fields: fields
    }
  end
end
