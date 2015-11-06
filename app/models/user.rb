class User < ActiveRecord::Base

  before_save { email.downcase! }

  has_one :session, dependent: :destroy

  has_secure_password
  validates :password, {
    length: { minimum: 8, message: "is too short (minimum is 8 characters)" },
     allow_nil: true # so that update doesn't require a password
   }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, {
    presence: true,
    length: { maximum: 50, message: "is too long (maximum is 50 characters)" },
    format: { with: VALID_EMAIL_REGEX, message: "format not recognized" },
    uniqueness: { case_sensitive: false }
  } 
end
