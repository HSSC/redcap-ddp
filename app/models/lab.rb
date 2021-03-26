#require 'sybase_connection'
class Lab #< Sybase::Connection
#  self.table_name = "EDW2.ORDER_RESULTS"
#  self.source_system = "EPIC"
#  self.id = "PatientExternalID"
#
#  def self.ddp_query(id, field_info)
#    #
#    #    select distinct
#    #            r.PatientExternalID,
#    #            xm.FIELD,
#    #            r.ResultsDTM,
#    #            r.ResultText
#    #    from craigje.DDP_RDC_XMAP_All xm
#    #      join EDW2.Order_Results r on (r.ComponentID = xm.SOURCE_CODE
#    #                  and xm.FIELD ='BLOOD_UREA_NITROGEN')
#    #    where r.PatientExternalID = '0002567977'
#    #    and date(r.ResultsDTM) between '2015-01-01' and '2015-01-31'
#
#    # make it 10 long and padded with 0
#    id = id.rjust(10, '0')
#
#    field_name = field_info['field']
#    metadata = Metadatum.where(field: field_name, version: Metadatum.current_version, source_tblname: field_info['source_tblname']).first
#
#    results = find(id, {:conditions => "ComponentID = #{metadata.source_code} AND date(ResultsDTM) between '#{field_info['timestamp_min']}' and '#{field_info['timestamp_max']}'"} )
#
#    # if we have results map them otherwise return nil
#    results.nil? ? nil : results.map{|x| {"field" => field_name, "value" => x['ResultText'], "timestamp" => x['ResultsDTM'].strftime('%Y-%m-%d %H:%M:%S')} }
#  end
end
