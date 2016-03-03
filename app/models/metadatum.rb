class Metadatum < ActiveRecord::Base
  def self.current_version
    Metadatum.maximum(:version).to_i
  end

  def self.klasses_for_field field
    source_tables = Metadatum.select(:source_tblname).where(:field => field, :version => current_version).map(&:source_tblname)
    
    klasses = []

    if source_tables.include? 'EDW2.PATIENTS'
      klasses << Patient
    elsif source_tables.include? 'EDW2.OPOBSERVATIONS'
      klasses << OutpatientVital
    elsif source_tables.include? 'EDW2.OBSERVATIONS'
      klasses << InpatientVital
    end

    klasses
  end
end
