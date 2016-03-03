class MetadataController < ApplicationController
  def index
    current_version = Metadatum.maximum(:version)
    render json: Metadatum.where(:version => current_version).to_a.uniq(&:field).to_json
  end
end
