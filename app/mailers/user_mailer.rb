class UserMailer < ActionMailer::Base
  default from: "order@planeta-avtodv.ru"

  def reset_password(user, password)
    @password = password
    @user = user
    mail to: @user.email, :reply_to => "order@planeta-avtodv.ru", subject: "Новый пароль"
  end
end
