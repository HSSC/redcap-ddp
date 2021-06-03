class Patient < ActiveRecord::Base
  establish_connection "rdw_#{Rails.env.to_s}".to_sym
  self.table_name = "RDM\.V_PATIENT"
  self.primary_key = 'patient_id'

  def self.ddp_query(id, field_info)

    # select distinct
    #        xm.FIELD,
    #        p.PAT_LAST_NAME as "Value"
    #from HNSTBRK.DDP_RDC_XMAP xm
    #  join RDM.V_PATIENT p on (xm.FIELD ='LastName')
    #
    #where p.PATIENT_MRN = '001033176'
    #
    # make it 10 long and padded with 0
    id = id.rjust(9, '0')

    field_name = field_info['field']
    metadata = Metadatum.where(field: field_name, version: Metadatum.current_version, source_tblname: field_info['source_tblname']).first

    result = find_by_patient_mrn id

    # if we have results map them otherwise return nil

    if result.nil?
      return nil
    else
      ### allow for special formatting of return data based on field requested ###
      case field_name
      when 'DeathDate'
        {"field" => field_name, "value" => (result["#{metadata.source_name.downcase}"].blank? ? nil : result["#{metadata.source_name.downcase}"].strftime("%Y-%m-%d"))}
      when 'BirthDate'
        {"field" => field_name, "value" => result["#{metadata.source_name.downcase}"].strftime("%Y-%m-%d")}
      else
        {"field" => field_name, "value" => result["#{metadata.source_name.downcase}"]}
      end
    end
  end
end
