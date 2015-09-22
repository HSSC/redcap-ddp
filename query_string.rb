require 'time'

module GlobalNamespace
  class QueryString
    PATIENTS_TABLE      = 'EDW2.Patients'
    ORDER_RESULTS_TABLE = 'EDW2.Order_Results'    
    TIMESTAMP_COLUMN    = "OrderDTM"
    
    def initialize(id)
      @id          = id
      @columns     = []
      @where       = ["#{PATIENTS_TABLE}.SourceSystem=\"EPIC\"", "#{PATIENTS_TABLE}.PatientExternalID=\"#{@id}\""]
      @from        = PATIENTS_TABLE
      @joins       = []
      @joins_on    = []
      @time_ranges = []
    end
    
    def sql_select(columns)
      @columns += columns.map { |col| col['field'] }
      self
    end
    
    def from(table)
      @from = table
      self
    end
    
    def join(table, on)
      @joins    << table
      @joins_on << on
      self
    end
    
    def where(*conjuncts)
      @where += conjuncts
      self
    end
    
    def time_range(from, to)
      @time_ranges << { from: Time.parse(from), to: Time.parse(to) }
      self
    end
    
    def to_s
      select_clause = "SELECT #{@columns.map { |col| prefix(col) }.join(',')}"
      from_clause   = "FROM #{@from}"
      unless @joins.empty?
        from_clause += " JOIN #{@joins[0]} ON #{@joins_on[0]}"
      end
      
      where_clause  = "WHERE #{@where.join(' AND ')}"
      
      unless @time_ranges.empty?
        # merge time ranges into a gross time range
        gross_from = @time_ranges.map { |tr| tr[:from] }.min.strftime('%Y-%m-%d %H:%M:%S')
        gross_to   = @time_ranges.map { |tr| tr[:to] }.max.strftime('%Y-%m-%d %H:%M:%S')
        
        where_clause += " AND (DATEFORMAT(#{prefix(TIMESTAMP_COLUMN)}, 'YYY-MM-DD HH:MM:SS') BETWEEN #{gross_from} AND #{gross_to})"
      end
      
      "#{select_clause} #{from_clause} #{where_clause}"
    end
    
    private
    
    def prefix(column)
      (GlobalNamespace.global_settings[:metadata].select { |f| f['field'] == column }.first)['category'] + "." + column
    end
  end
end