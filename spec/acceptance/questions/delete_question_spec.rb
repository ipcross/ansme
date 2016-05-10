require_relative '../acceptance_helper'

feature 'Delete question' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Logged user delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario 'Logged user tries to delete not his question' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Not logged user tries to delete any question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
