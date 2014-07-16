require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:example4.sqlite3"

require './models'
require 'bundler/setup'
require 'rack-flash'

set :sessions, true
use Rack::Flash, :sweep=>true

def current_user
	if session[:user_id]
		@current_user=User.find(session[:user_id])
	end
end

get '/' do
	redirect '/sign-in'
end

get '/sign-in' do
	erb :sign_in
end

post '/sign-in-process' do
	@user=User.find_by_email params[:email]
	if @user && @user.password==params[:password]
		flash[:message]="You are now in the matrix.</br>"
		session[:user_id]=@user.id
		redirect '/home'
	else
		flash[:message]="Great job dumbass. You've been killed by Agent Smith, but luckily you have more chances to enter the matrix."
		redirect '/sign-in'
	end
end

get '/home' do
	current_user
	erb :home
end