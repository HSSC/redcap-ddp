class Metadatum < ActiveRecord::Base
  def self.current_version
    Metadatum.maximum(:version).to_i
  end

  def self.klasses_for_field field
    source_tables = Metadatum.select(:source_tblname).where(:field => field, :version => current_version).map(&:source_tblname)

    klasses = []

    if source_tables.include? 'RDM.V_PATIENT'
      klasses << Patient
    elsif source_tables.include? 'RDM.OBSERVATION'
      klasses << Vital
    elsif source_tables.include? 'RDM.LAB_RESULT'
      klasses << Lab
    elsif source_tables.include? 'RDM.ORDER_RESULT'
      klasses << OrderResult
    end

    klasses
  end
end
