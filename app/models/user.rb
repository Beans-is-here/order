class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter2]

  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true
  
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]+\z/
  validates :password,
            format: {
              with: VALID_PASSWORD_REGEX,
              message: 'は半角英小文字、大文字、数字を含めてください'
            },
            if: -> { password.present? }

  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :recommendations, dependent: :destroy

  def self.twitter_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.name
      user.name = auth.info.nickname

      user.email = auth.info.email.present? ? auth.info.email : dummy_email(auth)
      user.password = Devise.friendly_token[0, 20]
    end
  end

  private
  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end