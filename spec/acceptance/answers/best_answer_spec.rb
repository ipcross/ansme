require_relative '../acceptance_helper'

feature 'Set Best Answer' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user) }

  scenario 'Logged user tries to set best answer' do
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_content 'Best'
  end

  scenario 'Not logged user tries to set best answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Best'
  end

  describe 'Author of question' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to set best answer', js: true do
      within("#answer-#{answer.id}") do
        click_link 'Best'
      end

      within '.answers' do
        expect(find("tr.info")[:id]).to eq "answer-#{answer.id}"
      end
    end

    scenario 'first answer is best', js: true do
      within("#answer-#{answer2.id}") do
        click_link 'Best'
      end

      within 'tbody' do
        expect(page.all('tr')[2][:id]).to eq "answer-#{answer2.id}"
      end
    end
  end
end
