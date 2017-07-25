require 'sinatra'
require 'rest-client'
require 'JSON'
require 'dotenv/load'

post '/disarm' do
  send_command_to_vehicle('disarm')
end

def session_id
  @_session_id ||= begin
    resp = RestClient.get("https://#{ENV['SMARTSTART_SERVER']}/auth/login/#{ENV['VIPER_USERNAME']}/#{ENV['VIPER_PASSWORD']}")
    JSON.parse(resp.body).dig("Return", "Results", "SessionID")
  end
end

def send_command_to_vehicle(command)
  RestClient.get("https://#{ENV['SMARTSTART_SERVER']}/device/sendcommand/1248171/#{command}?sessid=#{session_id}") do |response, request, result|
    case response.code
    when 200
      JSON.parse(response.body)
    else
      raise
    end
  end
end
