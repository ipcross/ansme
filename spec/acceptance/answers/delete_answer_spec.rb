require 'rails_helper'

feature 'Delete Answer' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario 'Logged user delete his answer' do
    sign_in(user)
    visit answer_path(answer)
    click_on 'Delete'

    expect(page).to_not have_content answer.body
  end

  scenario 'Logged user tries to delete not his answer' do
    sign_in(user2)
    visit answer_path(answer)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'Not logged user tries to delete answer' do
    visit answer_path(answer)

    expect(page).to_not have_link 'Delete'
  end
end
