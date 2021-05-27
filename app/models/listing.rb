class Listing < ApplicationRecord
  CONDITION = %w(Mint NearMint Good Average Bad)
  belongs_to :user
  has_one :purchase, dependent: :destroy
  has_many_attached :images
  validates :name, :price, :status, presence: true
  validates :item_condition, inclusion: { in: CONDITION }
  enum status: {active: 1, inactive: 2, purchased: 3}
  scope :active, -> { where(status: 1) }
  after_initialize :set_default_status

  def set_default_status
    self.status ||= 1
  end
end
 