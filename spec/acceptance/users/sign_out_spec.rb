require 'rails_helper'

feature 'User sign out' do
  given(:user) { create(:user) }

  scenario 'Logged user signs out' do
    sign_in(user)
    find("a[href='#{destroy_user_session_path}']").click

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
