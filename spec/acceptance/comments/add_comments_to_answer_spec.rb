require_relative '../acceptance_helper'

feature 'Add comment' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user try to comment answer', js: true do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_content 'Your comment'
    end
  end

  scenario 'Authenticated user comments answer', js: true do
    sign_in(user)
    answer
    visit question_path(question)
    within "#answer-#{answer.id}" do
      within '.answer-comment-form' do
        fill_in 'Your comment:', with: 'Answer comment'
        click_on 'Comment'
        wait_for_ajax
      end
    end
    # page.driver.debug
    # expect(page).to have_content user[:email]
    # expect(page).to have_content 'Answer comment'
  end
end
