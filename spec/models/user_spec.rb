require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    it 'nameが空の場合はinvalidとなるか。' do
      user_without_name = build(:user, name: '')
      expect(user_without_name).to be_invalid
      expect(user_without_name.errors[:name]).to eq ['を入力してください']
    end

    it 'emailが空の場合はinvalidとなるか。' do
      user_without_email = build(:user, email: '')
      expect(user_without_email).to be_invalid
      expect(user_without_email.errors[:email]).to eq ['を入力してください']
    end

    it 'emailが重複したらinvalidとなるか。' do
      user = create(:user)
      user_with_duplicated_email = build(:user, email: user.email)
      expect(user_with_duplicated_email).to be_invalid
      expect(user_with_duplicated_email.errors[:email]).to eq ['はすでに存在します']
    end

    it 'passwordが小文字のみならinvalidとなるか。' do
      user = build(:user, password: 'password', password_confirmation: 'password')
      expect(user).to be_invalid
      expect(user.errors[:password]).to eq ['は半角英小文字、大文字、数字を含めてください']
    end

    it 'passwordが大文字のみならinvalidとなるか。' do
      user = build(:user, password: 'PASSWORD', password_confirmation: 'PASSWORD')
      expect(user).to be_invalid
      expect(user.errors[:password]).to eq ['は半角英小文字、大文字、数字を含めてください']
    end

    it 'passwordが数字のみならinvalidとなるか。' do
      user = build(:user, password: '000000', password_confirmation: '000000')
      expect(user).to be_invalid
      expect(user.errors[:password]).to eq ['は半角英小文字、大文字、数字を含めてください']
    end

    it 'passwordに小文字が含まれないならinvalidとなるか。' do
      user = build(:user, password: 'PAS000', password_confirmation: 'PAS000')
      expect(user).to be_invalid
      expect(user.errors[:password]).to eq ['は半角英小文字、大文字、数字を含めてください']
    end

    it 'passwordに大文字が含まれないならinvalidとなるか。' do
      user = build(:user, password: 'pas000', password_confirmation: 'pas000')
      expect(user).to be_invalid
      expect(user.errors[:password]).to eq ['は半角英小文字、大文字、数字を含めてください']
    end

    it 'passwordに数字が含まれないならinvalidとなるか。' do
      user = build(:user, password: 'PASsword', password_confirmation: 'PASsword')
      expect(user).to be_invalid
      expect(user.errors[:password]).to eq ['は半角英小文字、大文字、数字を含めてください']
    end

    it 'passwordに記号が含まれているならinvalidとなるか。' do
      user = build(:user, password: 'PASsword0!', password_confirmation: 'PASsword0!')
      expect(user).to be_invalid
      expect(user.errors[:password]).to eq ['は半角英小文字、大文字、数字を含めてください']
    end

    it 'すべてのバリデーションが機能しているか' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end
  end

  describe 'oauthチェック' do
    let(:auth_hash) do
      OmniAuth::AuthHash.new({
                               provider: 'twitter2',
                               uid: '12345',
                               info: {
                                 name: 'テスト太郎',
                                 nickname: 'test_taro',
                                 email: 'test@example.com'
                               }
                             })
    end

    context 'ユーザー作成' do
      it 'ユーザーが作成される' do
        puts "テスト前のユーザー数: #{User.count}"
        puts "auth_hash: #{auth_hash}"
        expect do
          User.twitter_oauth(auth_hash)
        end.to change(User, :count).by(1)
      end

      it '属性が正しいユーザーが作成される' do
        user = User.twitter_oauth(auth_hash)
        expect(user.provider).to eq 'twitter2'
        expect(user.uid).to eq '12345'
        expect(user.username).to eq 'テスト太郎'
        expect(user.name).to eq 'test_taro'
        expect(user.email).to eq 'test@example.com'
        expect(user.password).to be_present
      end
    end

    context '既存ユーザー' do
      let!(:existing_user) do
        create(:user, provider: 'twitter2', uid: '12345')
      end

      it 'ユーザーが作成されない' do
        expect do
          User.twitter_oauth(auth_hash)
        end.not_to change(User, :count)
      end

      it '既存ユーザーが返される' do
        user = User.twitter_oauth(auth_hash)
        expect(user.id).to eq existing_user.id
      end
    end

    context 'Emailが存在しない' do
      let(:auth_hash_without_email) do
        OmniAuth::AuthHash.new({
                                 provider: 'twitter2',
                                 uid: '12345',
                                 info: {
                                   name: 'テスト太郎',
                                   nickname: 'test_taro',
                                   email: nil
                                 }
                               })
      end

      it 'ダミーEmailが生成される' do
        user = User.twitter_oauth(auth_hash_without_email)
        expect(user.email).to eq '12345-twitter2@example.com'
      end
    end
  end
end
