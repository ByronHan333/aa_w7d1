# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  attr_reader :password

  validates :username, uniqueness: true, presence: true
  validates :session_token, uniqueness: true, presence: true
  validates :password_digest, presence: true
  validates :password, length: {minimum: 6}, allow_nil: true

  before_validation :ensure_session_token


  has_many :cats,
    class_name: :Cat,
    foreign_key: :owner_id,
    dependent: :destroy,
    inverse_of: :owner # association's name

  def self.find_by_credentials(username, password)

    user = User.find_by(username: username)

    if user && user.is_password?(password)
      return user
    else
      return nil
    end

  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    bcrypt_object= BCrypt::Password.new(self.password_digest)
    bcrypt_object.is_password?(password)

  end

  def reset_session_token!
    self.session_token = generate_unique_session_token
    self.save!
    self.session_token
  end

  private
  def generate_unique_session_token
    loop do
      token = SecureRandom::urlsafe_base64(16)
      return token unless User.exists?(session_token: token)
    end
  end

  def ensure_session_token
    self.session_token ||= generate_unique_session_token
  end
end
