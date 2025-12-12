class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter2]

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name email created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[orders recommendations reviews]
  end

  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true

  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]+\z/
  validates :password,
            format: {
              with: VALID_PASSWORD_REGEX,
              message: :invalid_format
            },
            if: -> { password.present? }

  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :recommendations, dependent: :destroy

  def self.twitter_oauth(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user.username = auth.info.name
    user.name = auth.info.nickname
    user.email = auth.info.email.presence || dummy_email(auth)

    if user.new_record?
      user.password = generate_strong_password
      user.password_confirmation = user.password if user.respond_to?(:password_confirmation=)
    end

    user.save!
    user
  end

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  # ダミーパスワード生成
  require 'securerandom'
  private_class_method def self.generate_strong_password(length = 6)
    raise ArgumentError, 'length must be >= 6' if length < 6

    lower = ('a'..'z').to_a
    upper = ('A'..'Z').to_a
    digits = ('0'..'9').to_a
    all = lower + upper + digits

    # 必須文字を1つずつ選ぶ
    chars = []
    chars << lower[SecureRandom.random_number(lower.length)]
    chars << upper[SecureRandom.random_number(upper.length)]
    chars << digits[SecureRandom.random_number(digits.length)]

    # 残りは全体からランダムに選択
    (length - 3).times do
      chars << all[SecureRandom.random_number(all.length)]
    end

    # 文字列をシャッフルして返す
    chars.shuffle.join
  end
end
