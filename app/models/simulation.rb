class Simulation < ApplicationRecord
  belongs_to :user

  # Validazioni
  validates :grid_data, presence: true
  validates :rows, :cols, presence: true, numericality: { greater_than: 0 }
end
