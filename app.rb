require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error='something wrong' 
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do
 @user_name=params[:username]
 @phone=params[:phone]
 @date_time=params[:datetime]
 @barber=params[:barber]
 @color=params[:color]

  # хеш
 hh = { :username => 'Enter your name',
        :phone => 'Enter your phone',
        :datetime => 'Enter date and time' }
 @error = hh.select{|key,_| params[key] == ""}.values.join (", ")
 
 if @error != ''
 	return erb :visit
 end

 @title = 'Thank you!'
 @message = "Dear #{@user_name}, we'll be waiting for you at #{@date_time} "

 f=File.open 'users.txt', 'a'
 f.write "User: #{@user_name}, Phone: #{@phone}, Date and time: #{@date_time}, Color: #{@color} Barber: #{@barber}\n"
 f.close
 erb :message
end

get '/contacts' do
	erb :contacts
end

get '/admin' do
	erb :admin	
end

post '/admin' do
	@login=params[:aaa]
	@password=params[:bbb]

	if @login == 'admin' && @password == 'secret'
	@logfile = File.read ("users.txt")
	erb :list
	else
	@messageaccess = 'Access denied'
    end
end
