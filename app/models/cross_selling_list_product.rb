class CrossSellingListProduct < ActiveRecord::Base
  audited allow_mass_assignment: true
  
  validates :product_id, presence: true
  validates :cross_selling_list_id, presence: true

  belongs_to :product
  belongs_to :cross_selling_list, inverse_of: :cross_selling_list_products

  # Manual disambiguation, YO!
  scope :active, -> { where("#{self.class.table_name}.active", true) }

  def active?
    active == true
  end

end