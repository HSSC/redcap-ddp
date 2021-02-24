class RemoteMetadatum < ActiveRecord::Base
  establish_connection "rdw_#{Rails.env.to_s}".to_sym
  self.table_name = "HNSTBRK\.DDP_RDC_XMAP"
end
