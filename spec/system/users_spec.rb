RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe 'パスワードログイン機能' do
    it 'ログインできること' do
      visit new_user_session_path

      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログインする'

      expect(page).to have_content('ログインしました。')
      expect(current_path).to eq root_path
    end

    it 'ログインできない' do
      visit new_user_session_path

      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'wrong_password'
      click_button 'ログインする'

      expect(page).to have_content('メールアドレスまたはパスワードが違います。')
      expect(current_path).to eq new_user_session_path
    end
  end

  describe 'ログアウト機能' do
    before do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログインする'
      expect(page).to have_content('ログインしました。')
    end

    it 'ログアウトできること' do
      visit root_path
      click_button 'ログアウト'

      expect(page).to have_content('ログアウトしました。')
      expect(current_path).to eq root_path
    end
  end

#  describe 'topページからindexページに遷移する' do
#    context 'ログインしている場合' do
#      before do
#        visit new_user_session_path
#        fill_in 'メールアドレス', with: user.email
#        fill_in 'パスワード', with: user.password
#        click_button 'ログインする'
#        expect(page).to have_content('ログインしました。')
#      end
    #it 'ログインしていないなら登録画面' do
    #  visit root_path
    #  click_link '記録をはじめる'
    #  expect(current_path).to eq new_user_registration_path
    #end

#      it '投稿一覧に遷移する' do
#        visit root_path
        # デバッグ用：ページの内容を確認
#        expect(page).to have_link('記録をはじめる')
#        click_link '記録をはじめる'
#        expect(current_path).to eq orders_path
#      end
#    end
#  end
end
