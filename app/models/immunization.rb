class Immunization < ActiveRecord::Base
  establish_connection "rdw_#{Rails.env.to_s}".to_sym
  self.table_name = "RDM\.IMMUNIZATION"

  def self.ddp_query(id, field_info)

    p = Patient.find_by_patient_mrn id
    id = p.patient_id

    field_name = field_info['field']
    metadata = Metadatum.where(field: field_name, version: Metadatum.current_version, source_tblname: field_info['source_tblname']).first

    # observation_id and observation_date
    results = where(patient_id: id, imm_id: metadata.source_code, imm_date: field_info['timestamp_min']..field_info['timestamp_max'])

    # if we have results map them otherwise return nil
    if results.nil?
      nil
    else
      r_array = []

      results.each do |x|
        r_array << {"field" => field_name, "value" => x.imm_status, "timestamp" => x.imm_date.strftime('%Y-%m-%d %H:%M:%S')}
      end

      return r_array
    end
  end
end
