class ApplicationController < ActionController::Base
  # Додаємо Pundit для авторизації
  include Pundit::Authorization 

  # Якщо Pundit забороняє дію, виконуємо редирект
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  private

  def user_not_authorized
    # flash[:alert] використовується для повідомлень у сесії
    flash[:alert] = "Вам не дозволено виконувати цю дію."
    # Redirect_back з falllback_location, щоб не зламати додаток
    # status: :see_other потрібен для коректної роботи Turbo
    redirect_back(fallback_location: root_path, status: :see_other)
  end
end