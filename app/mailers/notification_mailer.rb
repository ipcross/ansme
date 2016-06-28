class NotificationMailer < ApplicationMailer
  def added_answer(user, answer)
    @user = user
    @answer = answer

    mail to: @user.email, subject: 'Ansme: added answer'
  end
end
