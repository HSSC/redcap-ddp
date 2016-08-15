require 'sybase_connection'
class InpatientVital < Sybase::Connection
  self.table_name = "EDW2.OBSERVATIONS"
  self.source_system = "EPIC"
  self.id = "PatientExternalID"
  
  def self.ddp_query(id, field_info)
    # select distinct xm.FIELD as field,  ob.MeasValue as 'value',  ob.TimeObservationMade as 'TimeStamp'
    #                         from craigje.DDP_RDC_XMAP xm
    #                           join EDW2.Observations ob on (ob.TID = xm.SOURCE_CODE and ob.DispName = xm.SOURCE_NAME) 
    #                           and xm.FIELD ='BP_Systolic'
    #                           where ob.PatientExternalID = '0001905325'
    #                           and date(ob.TimeObservationMade) between '2015-01-01' and '2015-01-31'

    # make it 10 long and padded with 0
    id = id.rjust(10, '0')

    field_name = field_info['field']
    metadata = Metadatum.where(field: field_name, version: Metadatum.current_version, source_tblname: field_info['source_tblname']).first

    results = find(id, {:conditions => "TID = #{metadata.source_code} AND DispName = '#{metadata.source_name}' AND date(TimeObservationMade) between '#{field_info['timestamp_min']}' and '#{field_info['timestamp_max']}'"} )

    # if we have results map them otherwise return nil
    results.nil? ? nil : results.map{|x| {"field" => field_name, "value" => x['MeasValue'], "timestamp" => x['TimeObservationMade'].strftime('%Y-%m-%d %H:%M:%S')} }
  end
end
