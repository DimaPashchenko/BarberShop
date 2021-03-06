require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
    db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
    barbers.each do |barber|
        if !is_barber_exists? db, barber
            db.execute 'insert into Barbers (name) values (?)', [barber]
        end
    end
end

def get_db
    db = SQLite3::Database.new 'barbershop.db'
    db.results_as_hash = true
    return db
end

before do
    db=get_db
    @barbers = db.execute 'select * from Barbers'    
end

configure do 
       db = get_db
       db.execute 'CREATE TABLE IF NOT EXISTS "Users"
        (
         "id" INTEGER PRIMARY KEY AUTOINCREMENT,
         "user_name" TEXT, 
         "phone" TEXT, 
         "datestamp" TEXT, 
         "barber" TEXT, 
         "color" TEXT
        )'

        db.execute 'CREATE TABLE IF NOT EXISTS "Barbers"
        (
         "id" INTEGER PRIMARY KEY AUTOINCREMENT,
         "name" TEXT  
        )'

        seed_db db, ['Jason Stetham', 'Bred Pit', 'Anjelina Joli', 'Pamela Anderson']
end



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
  @datetime=params[:datetime]
  @barber=params[:barber]
  @color=params[:color]

  # хеш для вывода ошибок
  hh = { :username => 'Enter your name',
        :phone => 'Enter your phone',
        :datetime => 'Enter date and time' }
  @error = hh.select{|key,_| params[key] == ""}.values.join (", ")
 
  if @error != ''
 	return erb :visit
  end
  
  db=get_db
  db.execute 'insert into Users
                            (
                                user_name, 
                                 phone,
                                 datestamp,
                                 barber,
                                 color
                            )
       values ( ?,?,?,?,?)', [@user_name, @phone, @datetime, @barber, @color]

   erb "<h2>Спасибо, вы записались!</h2>"
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

get '/showusers' do
    db = get_db
    @results = db.execute 'select * from Users order by id desc'
    erb :showusers 
end