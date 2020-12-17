class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # 未ログイン時にダイレクトに「http://localhost:3000/prototypes/new」されるのを防ぐため、
  # before_action :authenticate_user!
  # しようかと思ったが、ログイン画面に飛ばされるのが嫌だった。トップページに戻りたかったので。
  # ので、PrototypesControllerのnewアクションにて、if !user_signed_in?で条件分岐することにした。良かったか？
  # before_action :authenticate_user!のジャンプ先を指定できるのかな？

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:profile,:occupation,:position])
  end
end
