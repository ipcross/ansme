require 'rails_helper'

feature 'User sign in' do
  given(:user) { create(:user) }

  scenario 'Any user click to Login in navbar' do
    visit root_path
    click_on 'Login'

    expect(current_path).to eq new_user_session_path
  end

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Logged user try to edit his data' do
    sign_in(user)
    click_on user.email

    expect(page).to have_content 'Edit User'
    expect(current_path).to eq edit_user_registration_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
end
