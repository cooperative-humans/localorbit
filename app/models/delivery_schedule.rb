class DeliverySchedule < ActiveRecord::Base
  include SoftDelete

  WEEKDAYS = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)

  belongs_to :market, inverse_of: :delivery_schedules

  belongs_to :seller_fulfillment_location, class: MarketAddress
  belongs_to :buyer_pickup_location,       class: MarketAddress

  validates :day,          presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 6,   allow_nil: true}
  validates :order_cutoff, presence: true, numericality: {greater_than_or_equal_to: 6, less_than_or_equal_to: 504, allow_nil: true}
  validates :seller_fulfillment_location_id, presence: true
  validates :seller_delivery_start, presence: true
  validates :seller_delivery_end, presence: true
  validates :buyer_pickup_location_id, presence: true, unless: :direct_to_customer?
  validates :buyer_pickup_end,         presence: true, unless: :direct_to_customer?
  validates :buyer_pickup_start,       presence: true, unless: :direct_to_customer?

  validate :buyer_pickup_end_after_start,                      unless: :direct_to_customer?
  validate :buyer_pickup_start_after_seller_fulfillment_start, unless: :direct_to_customer?
  validate :seller_delivery_end_after_start

  def buyer_pickup?
    seller_fulfillment_location.present?
  end

  def seller_fulfillment_address
    if address = seller_fulfillment_location
      "#{address.address}, #{address.city}, #{address.state} #{address.zip}"
    else
      'Direct to customer'
    end
  end

  def weekday
    WEEKDAYS[day]
  end

  protected

  def buyer_pickup_end_after_start
    validate_time_after(:buyer_pickup_end, buyer_pickup_end, buyer_pickup_start, 'must be after buyer pickup start')
  end

  def buyer_pickup_start_after_seller_fulfillment_start
    validate_time_after(:buyer_pickup_start, buyer_pickup_start, seller_delivery_start, 'must be after delivery start')
  end

  def direct_to_customer?
    seller_fulfillment_location_id == 0
  end

  def seller_delivery_end_after_start
    validate_time_after(:seller_delivery_end, seller_delivery_end, seller_delivery_start, 'must be after delivery start')
  end

  def validate_time_after(field, before, after, message)
    return if before.nil? || after.nil?

    if Time.parse(before) <= Time.parse(after)
      errors.add(field, message)
    end
  end
end
