class Order < ActiveRecord::Base
  establish_connection "rdw_#{Rails.env.to_s}".to_sym
  self.table_name = "RDM\.ORDERS"
  self.primary_key = "order_id"

  belongs_to :patient, foreign_key: :patient_id
  has_many :order_results
end
