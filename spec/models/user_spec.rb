require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    it 'nameが空の場合はinvalidとなるか。' do
      user_without_name = build(:user, name: "")
      expect(user_without_name).to be_invalid
      expect(user_without_name.errors[:name]).to eq ["を入力してください"]
    end

    it 'emailが空の場合はinvalidとなるか。' do
      user_without_email = build(:user, email: "")
      expect(user_without_email).to be_invalid
      expect(user_without_email.errors[:email]).to eq ["を入力してください"]
    end

    it 'emailが重複したらinvalidとなるか。' do
      user = create(:user)
      user_with_duplicated_email = build(:user, email: user.email)
      expect(user_with_duplicated_email).to be_invalid
      expect(user_with_duplicated_email.errors[:email]).to eq ["はすでに存在します"]
    end

    it 'passwordが小文字のみならinvalidとなるか。' do
      user = build(:user, password: "password", password_confirmation: "password")
      expect(user).to be_invalid
      expect(user.errors[:password]).to eq ["は半角英小文字、大文字、数字を含めてください"]
    end

    it 'passwordが大文字のみならinvalidとなるか。' do
      user = build(:user, password: "PASSWORD", password_confirmation: "PASSWORD")
      expect(user).to be_invalid
      expect(user.errors[:password]).to eq ["は半角英小文字、大文字、数字を含めてください"]
    end

    it 'passwordが数字のみならinvalidとなるか。' do
      user = build(:user, password: "000000", password_confirmation: "000000")
      expect(user). to be_invalid
      expect(user.errors[:password]).to eq ["は半角英小文字、大文字、数字を含めてください"]
    end

    it 'passwordに小文字が含まれないならinvalidとなるか。' do
      user = build(:user, password: "PAS000", password_confirmation: "PAS000")
      expect(user). to be_invalid
      expect(user.errors[:password]).to eq ["は半角英小文字、大文字、数字を含めてください"]
    end

    it 'passwordに大文字が含まれないならinvalidとなるか。' do
      user = build(:user, password: "pas000", password_confirmation: "pas000")
      expect(user). to be_invalid
      expect(user.errors[:password]).to eq ["は半角英小文字、大文字、数字を含めてください"]
    end

    it 'passwordに数字が含まれないならinvalidとなるか。' do
      user = build(:user, password: "PASsword", password_confirmation: "PASsword")
      expect(user). to be_invalid
      expect(user.errors[:password]).to eq ["は半角英小文字、大文字、数字を含めてください"]
    end

    it 'passwordに記号が含まれているならinvalidとなるか。' do
      user = build(:user, password: "PASsword0!", password_confirmation: "PASsword0!")
      expect(user). to be_invalid
      expect(user.errors[:password]).to eq ["は半角英小文字、大文字、数字を含めてください"]
    end

    it 'すべてのバリデーションが機能しているか' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty          
    end
  end
end
