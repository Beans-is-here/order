require 'rails_helper'

RSpec.describe "Orders", type: :system do
  let(:user) { create(:user) }

  let!(:store1) { create(:store, user: user) }
  let!(:store2) { create(:store, user: user) }

  let!(:menu1) { create(:menu, store: store1) }
  let!(:menu2) { create(:menu, store: store2) }

  let!(:ordered_order) { create(:order, :ordered, user: user, menu: menu1) }
  let!(:wanted_order) { create(:order, :wanted, user: user, menu: menu2) }

  before do
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログインする'
    expect(page).to have_content('ログインしました。')
    visit orders_path
  end

  describe 'newアクション' do
    it "新規ページが作成される" do
      visit new_order_path
      expect(page).to have_field('ordered_true', type: 'radio')
      expect(page).to have_field('ordered_false', type: 'radio')

      expect(page).to have_field("order_form[store_name]")
      expect(page).to have_field("order_form[menu_name]")
      expect(page).to have_select("order_form[review_rating]")
      expect(page).to have_field("order_form[memo]")
      expect(page).to have_field("order_form[menu_image_url]", type: 'file')
      expect(page).to have_button("記録する")
    end

    it "ラジオボタンのデフォルトが設定されているか。" do
      visit new_order_path
      expect(page).to have_checked_field('ordered_true')
      expect(page).not_to have_checked_field('ordered_false')
    end

    it "ラジオボタンの切り替えが正常に動作するか" do
      visit new_order_path
      expect(page).to have_checked_field('ordered_true')

      choose 'ordered_false'
      expect(page).to have_checked_field('ordered_false')
      expect(page).not_to have_checked_field('ordered_true')

      choose 'ordered_true'
      expect(page).to have_checked_field('ordered_true')
      expect(page).not_to have_checked_field('ordered_false')
    end

    it "ラジオボタンのラベルが正常に表示されているか" do
      visit new_order_path
      expect(page).to have_content('オーダー済みメニューとして記録')
      expect(page).to have_content('気になるメニューとして記録')
    end
  end

  describe 'タブ機能' do
    it '"すべて"が機能している' do

      expect(page).to have_css('.tab-button.active', text: 'すべて')
      expect(page).to have_content(ordered_order.menu.name)
      expect(page).to have_content(wanted_order.menu.name)
    end

    it '"オーダー済み"タブが正常に機能している' do
      click_on 'オーダー済み'
      
      # タブの切り替え確認
      expect(page).to have_css('.tab-button.active', text: 'オーダー済み')
      
      expect(page).to have_content(ordered_order.menu.name)
    end

    it '"気になった"タブが正常に機能している' do
      click_on '気になった'
      
      # タブの切り替え確認
      expect(page).to have_css('.tab-button.active', text: '気になった')
      
      expect(page).to have_content(wanted_order.menu.name)
    end
  end
end
