# Preview all emails at http://localhost:3000/rails/mailers/daily_mayler
class DailyMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/daily_mayler/digest
  def digest
    DailyMailer.digest
  end
end
