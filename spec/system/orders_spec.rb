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

  describe "editページ遷移", js: true do  
    it "注文済みメニュー編集ページ" do
      expect(page).to have_css('#order-list')

      within("#order_#{ordered_order.id}") do
        click_link href: edit_order_path(ordered_order)
      end

      expect(page).to have_current_path(edit_order_path(ordered_order))
      expect(current_url).to include(ordered_order.id.to_s)  
      expect(current_url).not_to include(wanted_order.id.to_s)
    end

    it "気になるメニュー編集ページ" do
      expect(page).to have_css('#order-list')

      within("#order_#{wanted_order.id}") do
        click_link href: edit_order_path(wanted_order)
      end

      expect(page).to have_current_path(edit_order_path(wanted_order))
      expect(current_url).to include(wanted_order.id.to_s)  
      expect(current_url).not_to include(ordered_order.id.to_s)
    end
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

  describe 'create' do
    it "'オーダー済み'として記録できる", js: true do
      visit new_order_path
      fill_in 'order_form[store_name]', with: '店舗テスト'
      fill_in 'order_form[menu_name]', with: 'メニューテスト'
      choose 'ordered_true'
  
  # ファイルアップロードが必須の場合
  # attach_file 'order_form[menu_image_url]', Rails.root.join('spec/fixtures/test_image.jpg')
  
      expect {
        click_button '記録する'
        expect(page).to have_current_path(orders_path)
      }.to change(Order, :count).by(1)

      order = Order.last
      expect(order.menu.store.name).to eq('店舗テスト')
      expect(order.menu.name).to eq('メニューテスト')
      expect(order.ordered).to be true
    end

    it "'気になるメニュー'として記録できる", js: true do
      visit new_order_path
      fill_in 'order_form[store_name]', with: '店舗テスト2'
      fill_in 'order_form[menu_name]', with: 'メニューテスト2'
      choose 'ordered_false'

      expect {
        click_button '記録する'
        expect(page).to have_current_path(orders_path)
      }.to change(Order, :count).by(1)

      order = Order.last
      expect(order.menu.store.name).to eq('店舗テスト2')
      expect(order.menu.name).to eq('メニューテスト2')
      expect(order.ordered).to be false
    end
  end

  describe 'index タブ機能' do
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
