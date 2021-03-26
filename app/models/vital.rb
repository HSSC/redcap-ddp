class Vital < ActiveRecord::Base
  establish_connection "rdw_#{Rails.env.to_s}".to_sym
  self.table_name = "RDM\.OBSERVATION"

  def self.ddp_query(id, field_info)
    # select
    #         xm.FIELD,
    #         ob.OBSERVATION_VALUE as "Value",
    #         ob.OBSERVATION_DATE as "TimeStamp"
    #  from HNSTBRK.DDP_RDC_XMAP xm
    #   join RDM.OBSERVATION ob on (to_char(xm.SOURCE_CODE) = ob.OBSERVATION_ID)
    #   join RDM.PATIENT      p on (p.PATIENT_ID = ob.PATIENT_ID)
    #  where xm.FIELD = 'Height'
    #   and p.PATIENT_MRN = '001033176'
    #   and trunc(ob.OBSERVATION_DATE)
    #     between to_date('2020-01-01','YYYY-MM-DD') and to_date('2020-01-31','YYYY-MM-DD')

    # select distinct xm.FIELD as field,  ob.MeasValue as 'value',  ob.TimeObservationMade as 'TimeStamp'
    #                         from craigje.DDP_RDC_XMAP xm
    #                           join EDW2.Observations ob on (ob.TID = xm.SOURCE_CODE and ob.DispName = xm.SOURCE_NAME)
    #                           and xm.FIELD ='BP_Systolic'
    #                           where ob.PatientExternalID = '0001905325'
    #                           and date(ob.TimeObservationMade) between '2015-01-01' and '2015-01-31'

    p = Patient.find_by_patient_mrn id
    id = p.patient_id

    field_name = field_info['field']
    metadata = Metadatum.where(field: field_name, version: Metadatum.current_version, source_tblname: field_info['source_tblname']).first

    # observation_id and observation_date
    results = where(patient_id: id, observation_id: metadata.source_code, observation_date: field_info['timestamp_min']..field_info['timestamp_max']) #, :conditions => "TID = #{metadata.source_code} AND DispName = '#{metadata.source_name}' AND date(TimeObservationMade) between '#{field_info['timestamp_min']}' and '#{field_info['timestamp_max']}'"}

    # if we have results map them otherwise return nil
    if results.nil?
      nil
    else
      r_array = []

      results.each do |x|
        if metadata.source_value == 'OBSERVATION_VALUE'
          r_array << {"field" => field_name, "value" => x.observation_value, "timestamp" => x.observation_date.strftime('%Y-%m-%d %H:%M:%S')}
        else
          source_value = metadata.source_value.gsub('OBSERVATION_VALUE', "'#{x.observation_value}'")
          value = Vital.connection.exec_query("select #{source_value} as x from dual").to_a.first['x']
          r_array << {"field" => field_name, "value" => value, "timestamp" => x.observation_date.strftime('%Y-%m-%d %H:%M:%S')}
        end
      end

      return r_array
    end
  end
end
