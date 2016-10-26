class DataController < ApplicationController
  def index
    # {"user"=>"anc63", "project_id"=>"36", "redcap_url"=>"https://redcap-dev.obis.musc.edu/", "id"=>"123456",
    #  "fields"=>[{"field"=>"FirstName"}, {"field"=>"LastName"}], "controller"=>"data", "action"=>"index",
    #  "datum"=>{"user"=>"anc63", "project_id"=>"36", "redcap_url"=>"https://redcap-dev.obis.musc.edu/", "id"=>"123456", "fields"=>[{"field"=>"FirstName"}, {"field"=>"LastName"}]}}

    puts "#"*50
    puts "params:"
    puts params.inspect
    puts "#"*50

    user = params['user']
    project_id = params['project_id']
    redcap_url = params['redcap_url']
    id = params['id']
    fields = params['fields']

    results = []

    if fields
      fields.each do |field_info|
        # field info examples {"field"=>"FirstName"} OR {"field"=>"BP_Systolic", "timestamp_min" => '', "timestamp_max" => ''}
        Metadatum.klasses_for_field(field_info['field']).each do |klass|
          field_info['source_tblname'] = klass.table_name # added so we know which table in case of multiple
          results << klass.ddp_query(id, field_info)
        end
      end
    end

    results.flatten!

    puts "#"*50
    puts "results:"
    puts results.to_json
    puts "#"*50

    render json: results.to_json
  end
end
