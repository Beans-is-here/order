class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
end