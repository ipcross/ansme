require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #index" do
    it 'calls full_search method' do
      expect(Search).to receive(:full_search).with('test', '')
      get :index, content: 'test', context: ''
    end

    it 'renders template index' do
      get :index, content: '', context: ''
      expect(response).to render_template 'index'
    end
  end
end
