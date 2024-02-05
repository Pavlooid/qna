class Subscribe
  def send_subscribe(answer)
    subscribes = answer.question.subscribes
    subscribes.each do |s|
      SubscribeMailer.send_info(s.user, answer).deliver_later
  end
end
