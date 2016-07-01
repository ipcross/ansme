require_relative '../acceptance_helper'

feature 'search' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer) }

  background do
    index
    visit root_path
  end

  scenario 'not found', js: true do
    fill_in 'content', with: "mege very big word"
    click_on 'Search'
    expect(page).to have_content "Results not found"
  end

  scenario 'in all context', js: true do
    click_on 'Search'
    expect(page).to have_content user.email
    expect(page).to have_content question.title
    expect(page).to have_content answer.body
    expect(page).to have_content comment.body
  end

  scenario 'in questions context', js: true do
    select 'questions', from: 'context'
    fill_in 'content', with: question.body
    click_on 'Search'
    expect(page).to_not have_content user.email
    expect(page).to have_content question.title
    expect(page).to_not have_content answer.body
    expect(page).to_not have_content comment.body
  end

  scenario 'in answers context', js: true do
    select 'answers', from: 'context'
    fill_in 'content', with: answer.body
    click_on 'Search'
    expect(page).to_not have_content user.email
    expect(page).to_not have_content question.title
    expect(page).to have_content answer.body
    expect(page).to_not have_content comment.body
  end

  scenario 'in comments context', js: true do
    select 'comments', from: 'context'
    fill_in 'content', with: comment.body
    click_on 'Search'
    expect(page).to_not have_content user.email
    expect(page).to_not have_content question.title
    expect(page).to_not have_content answer.body
    expect(page).to have_content comment.body
  end

  scenario 'in users context', js: true do
    select 'users', from: 'context'
    fill_in 'content', with: user.email
    click_on 'Search'
    expect(page).to have_content user.email
    expect(page).to_not have_content question.title
    expect(page).to_not have_content answer.body
    expect(page).to_not have_content comment.body
  end
end
