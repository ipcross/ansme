require_relative '../acceptance_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to answer', js: true do
    fill_in 'new-answer-form', with: 'My answer'
    click_on 'Add attachment'
    wait_for_ajax
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end
