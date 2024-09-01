class User < ApplicationRecord
  extend Enumerize
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :gender, presence: true
  validates :phone_number, length: { minimum: 10 }, allow_blank: true
  validate :phone_number_format
  validate :password_complexity

  enumerize :gender, in: [:male, :female, :others]
  enumerize :role, in: [:admin, :manager, :content_writer, :user], default: :user, scope: true

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [74, 74], crop: :attention
    attachable.variant :icon, resize_to_limit: [36, 36], crop: :attention
  end

  private

  def phone_number_format
    if phone_number.present? && !phone_number.start_with?('+')
      errors.add(:phone_number, 'must start with "+"')
    end
  end

  def password_complexity
    return if password.blank?

    unless password =~ /(?=.*[A-Za-z])(?=.*\d)(?=.*[.@$!%*?&])/
      errors.add :password, 'must contain at least one letter, one number, and one special character'
    end
  end
end
