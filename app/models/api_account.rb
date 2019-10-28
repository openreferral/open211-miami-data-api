class ApiAccount < ApplicationRecord
  validates :api_key, presence: true, uniqueness: true

  before_validation :generate_api_key

  def generate_api_key
    return if self[:api_key].present?

    self[:api_key] = loop do
      token = SecureRandom.urlsafe_base64
      break token unless ApiAccount.exists?(api_key: token)
    end
  end
end
