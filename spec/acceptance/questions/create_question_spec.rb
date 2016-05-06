require 'rails_helper'

feature 'Create question' do
  given(:user) { create(:user) }

  scenario 'Authenticated user create the question' do
    sign_in(user)

    visit root_path
    click_on 'Ask Question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Non-authenticated user try to create question' do
    visit root_path

    expect(page).not_to have_link 'Ask Question'
  end
end
