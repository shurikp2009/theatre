class Show < ApplicationRecord
  validate :no_date_conflict, on: :create

  scope :runs_on, ->(date) { where("date_from <= ? and date_to >= ?", date, date) }

  scope :stictly_within, ->(start, finish) { where("date_from > ? and date_to < ?", start, finish) }

  def no_date_conflict
    if self.class.runs_on(date_from).exists? || 
       self.class.runs_on(date_to).exists? ||
       self.class.stictly_within(date_from, date_to).exists?

      errors.add(:base, "date conflict")
    end
  end
end
