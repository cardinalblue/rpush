require 'unit_spec_helper'

describe Rpush::Client::ActiveRecord::Wns::ToastImageNotification do
  let(:notification) do
    notif = Rpush::Client::ActiveRecord::Wns::ToastImageNotification.new
    notif.app  = Rpush::Client::ActiveRecord::Wns::App.new(name: "aname")
    notif.uri  = 'https://db5.notify.windows.com/?token=TOKEN'
    notif.badge = 42
    notif
  end

  it 'should allow a notification without data' do
    expect(notification.valid?).to be(true)
  end
end if active_record?
