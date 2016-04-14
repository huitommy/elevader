class UserMailer < ActionMailer::Base
  default from: "noreply@elevader.com"
  def added_review(user, elevator)
    @user = user
    @elevator = elevator
    mail(to: "#{@user.email}, subject: 'Your elevator has a new Review!'")
  end
end
