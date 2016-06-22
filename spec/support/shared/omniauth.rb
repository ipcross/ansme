shared_examples_for "Omniauthable" do
  context 'email not returned' do
    before do
      do_request(info: {email: nil})
    end

    it 'stores data in session' do
      expect(session['devise.oauth_data'][:provider]).to eq provider
      expect(session['devise.oauth_data'][:uid]).to eq '123456'
    end
    it { should_not be_user_signed_in }
    it { should redirect_to new_authorization_path }
  end

  context 'user dont exist yet' do
    before do
      do_request
    end

    it 'assigns user to @user' do
      expect(assigns(:user)).to be_a(User)
    end
    it { should be_user_signed_in }
  end

  context 'found user without authorization' do
    before do
      user
      do_request(info: {email: user.email})
    end

    it 'assigns user to @user' do
      expect(assigns(:user)).to eq user
    end
    it { should be_user_signed_in }
  end

  context 'found user with authorization' do
    let(:auth) { create(:authorization, provider: provider, user: user) }
    before do
      do_request(provider: auth.provider, uid: auth.uid, info: {email: user.email})
    end

    it 'assigns user to @user' do
      expect(assigns(:user)).to eq user
    end
    it { should be_user_signed_in }
  end

  def do_request(options = {})
    request.env["omniauth.auth"] = OmniAuth::AuthHash.new(provider: provider, uid: '123456', info: { email: 'new-user@email.com' }).merge(options)
    get provider.to_sym
  end
end
