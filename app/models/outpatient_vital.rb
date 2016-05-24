require 'sybase_connection'
class OutpatientVital < Sybase::Connection
  self.table_name = "EDW2.OPOBSERVATIONS"
  self.source_system = "EPIC"
  self.id = "PatientExternalID"
  
  def self.ddp_query(id, field_info)
    # select distinct xm.FIELD as field,  ob.MeasValue as 'value',  ob.TimeObservationMade as 'TimeStamp'
    #                         from craigje.DDP_RDC_XMAP xm
    #                           join EDW2.OpObservations ob on (ob.TID = xm.SOURCE_CODE and ob.DispName = xm.SOURCE_NAME) 
    #                           and xm.FIELD ='BP_Systolic'
    #                           where ob.PatientExternalID = '0001905325'
    #                           and date(ob.TimeObservationMade) between '2015-01-01' and '2015-01-31'

    field_name = field_info['field']
    metadata = Metadatum.where(field: field_name, version: Metadatum.current_version, source_tblname: field_info['source_tblname']).first

    results = find(id, {:conditions => "TID = #{metadata.source_code} AND DispName = '#{metadata.source_name}' AND date(TimeObservationMade) between '#{field_info['timestamp_min']}' and '#{field_info['timestamp_max']}'"} )
    results.map{|x| {"field" => field_name, "value" => x['MeasValue'], "timestamp" => x['TimeObservationMade'].strftime('%Y-%m-%d %H:%M:%S')} }
  end
end