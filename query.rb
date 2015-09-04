class Query < DbClient

  PATIENTS_TABLE = 'EDW2.Patients'

  def initialize(id, fields)
    @id = id
    @fields = fields
  end

  def execute
    columns = @fields.map { |f| f['field'] }.join(',')
    puts "Query: columns=#{columns}"
    client.execute("SELECT #{columns} FROM #{PATIENTS_TABLE} WHERE SourceSystem=\"EPIC\" AND PatientExternalID=\"#{@id}\"")
  end
end
