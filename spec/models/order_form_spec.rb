require 'rails_helper'

RSpec.describe OrderForm, type: :model do
  let(:user) { create(:user) }

  #  describe 'バリデーションチェック' do
  #    context '正常時' do
  #      it 'バリデーションが通ること' do
  # ActiveModel::Attributesを使用している場合、initializeメソッドに直接キーワード引数として属性を渡すことができないハッシュで渡す。
  #        form = OrderForm.new(
  #          store_name: '店舗テスト',
  #          menu_name: 'メニューテスト',
  #          memo: 'メモテスト',
  #          ordered: true,
  #          user: user
  #        )

  describe 'バリデーションチェック' do
    context '正常時' do
      it 'バリデーションが通ること' do
        attributes = build(:order_form_attributes)
        form = OrderForm.new(attributes, user: user)
        expect(form).to be_valid
      end
    end

    context 'store_nameが空の場合' do
      it 'バリデーションエラーが発生すること' do
        attributes = build(:order_form_attributes, :invalid_store_name)
        form = OrderForm.new(attributes, user: user)
        expect(form).to be_invalid
        expect(form.errors[:store_name]).to include('を入力してください')
      end
    end

    context 'menu_nameが空の場合' do
      it 'バリデーションエラーが発生すること' do
        attributes = build(:order_form_attributes, :invalid_menu_name)
        form = OrderForm.new(attributes, user: user)
        expect(form).to be_invalid
        expect(form.errors[:menu_name]).to include('を入力してください')
      end
    end

    context 'memoが40文字を超える場合' do
      it 'バリデーションエラーが発生すること' do
        attributes = build(:order_form_attributes, :long_memo)
        form = OrderForm.new(attributes, user: user)
        expect(form).to be_invalid
        expect(form.errors[:memo]).to include('は40文字以内で入力してください')
      end
    end
  end
  # FormObjectではバリデーションと実際の処理を分けてテストするのがベストプラクティス　らしい。
  describe '#save' do
    context '正常なデータの場合' do
      it 'Store, Menu, Orderが作成されること' do
        attributes = build(:order_form_attributes)
        form = OrderForm.new(attributes, user: user)
        expect do
          form.save
        end.to change(Store, :count).by(1)
                                    .and change(Menu, :count).by(1)
                                                             .and change(Order, :count).by(1)
      end
    end

    context 'reviewが設定されている場合' do
      it 'Reviewも作成されること' do
        attributes = build(:order_form_attributes, :with_review)
        form = OrderForm.new(attributes, user: user)
        expect do
          form.save
        end.to change(Review, :count).by(1)
      end
    end

    context 'バリデーションエラーの場合' do
      it 'falseを返すこと' do
        attributes = build(:order_form_attributes, :invalid_store_name)
        form = OrderForm.new(attributes, user: user)
        expect(form.save).to be false
        expect(form.errors[:store_name]).to be_present
      end
    end
  end
end
