require 'spec_helper'

RSpec.describe '/metadata' do

  describe 'success' do

    before { post '/metadata', params }
    
    it 'should return a status code of 200' do
       expect(last_response.status).to eq(200)
    end

    it "should return a content-type of 'application/json'" do
       expect(last_response.content_type).to eq('application/json')
    end
  end

  def params
    {
      user: 1,
      project_id: 1,
      redcap_url: 'http://www.google.com'
    }
  end
end
