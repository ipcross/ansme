require_relative '../acceptance_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }

  background do
    create(:answer_attachment, attachable: answer)
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User add files to answer', js: true do
    fill_in 'new-answer-form', with: 'My answer'
    click_on 'Add attachment'
    wait_for_ajax
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add attachment'
    wait_for_ajax
    within '.nested-fields:nth-of-type(2)' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Create'
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end

  scenario 'User delete file from answer', js: true do
    expect(page).to have_content 'spec_helper.rb'
    within '.answers' do
      click_link 'Edit'
      click_on 'remove attach'
      click_on 'Save'
      expect(page).not_to have_link 'spec_helper.rb'
    end
  end
end
