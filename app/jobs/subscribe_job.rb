class SubscribeJob < ApplicationJob
  queue_as :default

  def perform(object)
    SubscribeService.new.send_subscribe(object)
  end
end
