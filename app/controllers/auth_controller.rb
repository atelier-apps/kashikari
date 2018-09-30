class AuthController < ApplicationController
  def callback

    code = params[:code]
    status = params[:status]

    require "net/https"
    require "uri"

    url = URI.parse('https://api.line.me/v2/oauth/accessToken')
    req = Net::HTTP::Post.new(url.path, initheader = {'Content-Type' =>'application/x-www-form-urlencoded'})
    req.set_form_data({
      "code" => code,
      "redirect_uri" => "https%3A%2F%2Fc1e0643.ngrok.io%2F",
      "grant_type"   => "authorization_code",
      "client_id"   => "1611112902",
      "client_secret" => "e3d33d2337427187594e141184784d38"
      }, '&')


    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res=http.request(req)


    puts "----------------"
    puts "Response #{req.body}"

    puts "----------------"
    puts "Response #{res.code} #{res.message}: #{res.body}"
    puts "----------------"

  end
end
