class SubscribeMailer < ApplicationMailer
  def send_info(user, answer)
    @answer = answer
    mail to user.email
  end
end
