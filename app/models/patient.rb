require 'sybase_connection'
class Patient < Sybase::Connection
  self.table_name = "EDW2.Patients"
  self.source_system = "EPIC"
  self.id = "PatientExternalID"

  def self.ddp_query(id, field_info)
    field_name = field_info['field']
    results = find(id, :select => field_name)
    results.map{|x| {"field" => field_name, "value" => x["#{field_name}"]} }
  end
end
