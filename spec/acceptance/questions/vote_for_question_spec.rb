require_relative '../acceptance_helper'

feature 'Vote for question' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user2) }
  given!(:own_question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes up for question', js: true do
      within '.question' do
        click_on 'up'

        expect(page).to have_content 'Raiting:1'
        expect(page).to have_button('up', disabled: true)
        expect(page).to have_button('down', disabled: true)
        expect(page).to have_button('clean', disabled: false)
      end
    end

    scenario 'votes down for question', js: true do
      within '.question' do
        click_on 'down'

        expect(page).to have_content 'Raiting:-1'
        expect(page).to have_button('up', disabled: true)
        expect(page).to have_button('down', disabled: true)
        expect(page).to have_button('clean', disabled: false)
      end
    end

    scenario 'clean vote for question', js: true do
      within '.question' do
        click_on 'up'
        expect(page).to have_content 'Raiting:1'

        click_on 'clean'
        expect(page).to have_content 'Raiting:0'
        expect(page).to have_button('up', disabled: false)
        expect(page).to have_button('down', disabled: false)
        expect(page).to have_button('clean', disabled: true)
      end
    end

    scenario 'tryes to vote for his own question', js: true do
      visit question_path(own_question)

      within '.question' do
        expect(page).to_not have_button 'up' && 'down' && 'clean'
      end
    end
  end

  scenario 'Non-Authenticated user tryes to vote for answer', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_button 'up' && 'down' && 'clean'
    end
  end
end
