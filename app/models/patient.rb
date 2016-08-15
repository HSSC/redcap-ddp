require 'sybase_connection'
class Patient < Sybase::Connection
  self.table_name = "EDW2.Patients"
  self.source_system = "EPIC"
  self.id = "PatientExternalID"

  def self.ddp_query(id, field_info)
    # make it 10 long and padded with 0
    id = id.rjust(10, '0')

    field_name = field_info['field']
    results = find(id, :select => field_name)

    # if we have results map them otherwise return nil
    results.nil? ? nil : results.map{|x| {"field" => field_name, "value" => x["#{field_name}"]} }
  end
end
