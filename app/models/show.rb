class Show < ApplicationRecord
  validate :validate_period
  validate :no_date_conflict, on: :create

  validates :title, presence: true
  
  scope :overlapping, ->(period) { where("period && #{date_range_to_db(period)}") }

  delegate :overlapping, :valid_period?, to: 'self.class'
  
  def no_date_conflict
    if valid_period?(period) && overlapping(period).exists?
      errors.add(:base, "date conflict")
    end
  end

  class << self
    def date_range_to_db(period)
      "'[ #{period.begin.to_s(:db)}, #{period.end.to_s(:db)} ]'"
    end

    def valid_period?(period)
      period.is_a?(Range) && 
        period.begin.is_a?(Date) && 
        period.end.is_a?(Date) && 
        period.begin <= period.end
    end
  end

  def period=(value_from_params)
    write_attribute(:period, parse_period_string(value_from_params))
  end

  # or date_from=, date_to= to construct range

  def parse_period_string(value)
    value # TODO
  end

  def validate_period
    errors.add(:period, 'invalid') unless valid_period?(period)
  end
end
