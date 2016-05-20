require_relative '../acceptance_helper'

feature 'Delete Answer' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Logged user delete his answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_link 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'Logged user tries to delete not his answer' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Not logged user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
