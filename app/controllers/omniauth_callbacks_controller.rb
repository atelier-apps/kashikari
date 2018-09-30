class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line; basic_action end

  private

 def basic_action
   @omniauth = request.env['omniauth.auth']
   puts @omniauth
   if @omniauth.present?
     @profile = User.where(provider: @omniauth['provider'], uid: @omniauth['uid']).first
     if @profile
       @profile.set_values(@omniauth)
       sign_in(:user, @profile)
     else
       @profile = User.new(provider: @omniauth['provider'], uid: @omniauth['uid'], image: @omniauth['info']['image'], description: @omniauth['info']['description'])
       email = @omniauth['info']['email'] ? @omniauth['info']['email'] : "#{@omniauth['uid']}-#{@omniauth['provider']}@example.com"
       @profile = current_user || User.create!(provider: @omniauth['provider'], uid: @omniauth['uid'], email: email, name: @omniauth['info']['name'], image: @omniauth['info']['image'], description: @omniauth['info']['description'], password: Devise.friendly_token[0, 20])
       @profile.set_values(@omniauth)
       sign_in(:user, @profile)
       # redirect_to edit_user_path(@profile.user.id) and return

     end
   end

   flash[:notice] = "ログインしました"
   redirect_to root_path
 end


 def fake_email(uid,provider)
    return "#{auth.uid}-#{auth.provider}@example.com"
 end
end
