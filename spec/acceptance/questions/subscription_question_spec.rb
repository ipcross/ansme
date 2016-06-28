require_relative '../acceptance_helper'

feature 'Subscription to question' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user2) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'subscribes to question', js: true do
      within '.question' do
        click_on 'Subscribe'
        expect(page).to have_link('Unsubscribe')
      end
    end

    scenario 'unsubscribes to question', js: true do
      within '.question' do
        click_on 'Subscribe'
        click_on 'Unsubscribe'
        expect(page).to have_link('Subscribe')
      end
    end

    scenario 'receives email with answer', js: true do
      click_on 'Subscribe'
      fill_in 'new-answer-form', with: 'My answer'
      click_on 'Create'
      sleep(1)
      open_email(user.email)
      expect(current_email).to have_content 'My answer'
      current_email.save_and_open
    end
  end

  scenario 'Non-Authenticated user tryes to subscribe to question', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_button 'Subscribe' && 'Unsubscribe'
    end
  end
end
