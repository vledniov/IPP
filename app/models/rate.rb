class Rate < ActiveRecord::Base
  validates :made_on,       presence: true
  validates :currency_code, presence: true
  validates :value,         presence: true
end
