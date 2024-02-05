class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daidy_digest_mailer.digest.subject
  #
  def digest(user)
    @new_questions = Questions.where('created_at > ?', 1.day.ago)

    mail to: user.email if @new_questions.any?
  end
end
