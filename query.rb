class Query < DbClient

  PATIENTS_TABLE = 'EDW2.Patients'

  def initialize(id, fields)
    @id = id
    @fields = fields
  end

  def execute
    results = []
    rows    = client.execute("SELECT #{columns} FROM #{PATIENTS_TABLE} WHERE SourceSystem=\"EPIC\" AND PatientExternalID=\"#{@id}\"")

    rows.each do |row| 
      row.each { |key, value| results.push({ field: key, value:  value }) }
    end

    results
  end

  private

  def columns
    @fields.map { |f| f['field'] }.join(',')
  end
end
