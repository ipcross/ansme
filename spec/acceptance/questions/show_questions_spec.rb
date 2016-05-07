require 'rails_helper'

feature 'show questions' do
  given(:question) { create(:question) }

  scenario 'user views questions' do
    question
    question2 = create(:question)
    visit root_path
    expect(page).to have_content question.title
    expect(page).to have_content question2.title
  end

  scenario 'user can view question and answers' do
    answer1 = create(:answer, question: question)
    answer2 = create(:answer, question: question)
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer1.body
    expect(page).to have_content answer2.body
  end
end
