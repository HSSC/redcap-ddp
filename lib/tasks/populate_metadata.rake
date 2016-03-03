desc "Populate metadata table"
task populate_metadata: :environment do
  require 'sybase_connection'
  class RemoteMetadata < Sybase::Connection; end

  rmd = RemoteMetadata.execute "SELECT FIELD, LABEL, DESCRIPTION, TEMPORAL, CATEGORY, SUBCATEGORY, IDENTIFIER, SOURCE_TBLNAME, SOURCE_CODE, SOURCE_NAME, SOURCE_TEMPORAL, SOURCE_VALUE FROM craigje.DDP_RDC_XMAP"

  if rmd.size > 0 # we have remote metadata
    current_version = Metadatum.current_version
    next_version = current_version + 1

    rmd.each do |metadata|
      Metadatum.create field: metadata['FIELD'],
        label: metadata['LABEL'],
        description: metadata['DESCRIPTION'],
        temporal: metadata['TEMPORAL'],
        category: metadata['CATEGORY'],
        subcategory: metadata['SUBCATEGORY'],
        identifier: metadata['IDENTIFIER'],
        source_tblname: metadata['SOURCE_TBLNAME'],
        source_code: metadata['SOURCE_CODE'],
        source_name: metadata['SOURCE_NAME'],
        source_temporal: metadata['SOURCE_TEMPORAL'],
        source_value: metadata['SOURCE_VALUE'],
        version: next_version
    end
  end
end
