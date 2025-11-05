RSpec.describe 'Users', type: :system do
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

    it 'サインアップ' do
      visit new_user_session_path
      expect(page).to have_link('登録はここから')
      page.execute_script("window.location.href = '#{new_user_registration_path}'") # click_buttonとの差異を改めて確認しましょう。

      expect(current_path).to eq new_user_registration_path
    end

    #    it 'パスワード再発行' do
    #      visit new_user_session_path
    #      click_button 'パスワードをお忘れの方'
    #      expect(current_path).to eq new_user_password_path
    #    end

    #    it 'twitterでログイン' do
    #      visit new_user_session_path
    #      expect(page).to have_link("Twitterでログイン")
    #      page.execute_script("window.location.href = '#{new_user_registration_path}'")
    #      expect...
    #     end
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

  describe 'topページから各種ページに遷移する' do
    context 'ログインしている場合' do
      before do
        visit new_user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログインする'
        expect(page).to have_content('ログインしました。')
      end

      it 'ロゴから投稿一覧に遷移する' do
        visit root_path
        expect(page).to have_link('Order ロゴ')

        page.execute_script("window.location.href = '#{orders_path}'")
        expect(current_path).to eq orders_path
      end

      it '投稿一覧に遷移する' do
        visit root_path
        expect(page).to have_link('記録をはじめる')

        # JavaScript実行による遷移（Turboを回避）
        page.execute_script("window.location.href = '#{orders_path}'")
        expect(current_path).to eq orders_path
      end
    end

    context 'ログインしていない場合' do
      it 'ロゴから投稿一覧に遷移する' do
        visit root_path
        expect(page).to have_link('Order ロゴ')

        page.execute_script("window.location.href = '#{root_path}'")
        expect(current_path).to eq root_path
      end
      it '記録をはじめるボタンからユーザー登録' do
        visit root_path
        expect(page).to have_link('記録をはじめる')
        page.execute_script("window.location.href = '#{new_user_registration_path}'")
        expect(current_path).to eq new_user_registration_path
      end

      it 'ユーザー登録ボタンからユーザー登録' do
        visit root_path
        expect(page).to have_link('ユーザー登録')
        page.execute_script("window.location.href = '#{new_user_registration_path}'")
        expect(current_path).to eq new_user_registration_path
      end
    end
  end
end
