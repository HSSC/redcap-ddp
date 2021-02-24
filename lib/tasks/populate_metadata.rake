desc "Populate metadata table"
task populate_metadata: :environment do

  rmd = RemoteMetadatum.all
  # ["field", "label", "description", "temporal", "category", "subcategory", "identifier", "source_tblname", "source_code", "source_name", "source_temporal", "source_value"]

  if rmd.size > 0 # we have remote metadata
    current_version = Metadatum.current_version
    next_version = current_version + 1

    rmd.each do |metadata|
      Metadatum.create field: metadata.field,
        label: metadata.label,
        description: metadata.description,
        temporal: metadata.temporal,
        category: metadata.category,
        subcategory: metadata.subcategory,
        identifier: metadata.identifier,
        source_tblname: metadata.source_tblname,
        source_code: metadata.source_code,
        source_name: metadata.source_name,
        source_temporal: metadata.source_temporal,
        source_value: metadata.source_value,
        version: next_version
    end
  end
end
