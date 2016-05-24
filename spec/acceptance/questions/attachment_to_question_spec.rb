require_relative '../acceptance_helper'

feature 'Attachments for question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
  end

  scenario 'User add files when asks question', js: true do
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text text'
    click_on 'Add attachment'
    wait_for_ajax
    within '.nested-fields:nth-of-type(1)' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Add attachment'
    wait_for_ajax
    within '.nested-fields:nth-of-type(2)' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Create'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

  scenario 'User add file when edit question', js: true do
    visit edit_question_path(question)
    click_on 'Add attachment'
    wait_for_ajax
    attach_file 'File', "#{Rails.root}/spec/shoulda_matchers_helper.rb"
    click_on 'Update'
    expect(page).to have_link 'shoulda_matchers_helper.rb'
  end

  scenario 'User delete file from question', js: true do
    create(:question_attachment, attachable: question)
    visit edit_question_path(question)
    expect(page).to have_content 'spec_helper.rb'
    click_on 'remove attach'
    click_on 'Update Question'
    expect(page).not_to have_link 'spec_helper.rb'
  end
end
