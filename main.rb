require 'sinatra'
require 'json'

get '/' do
  'nothing here please see the API documentation'
end

post '/addEmployee' do
  id = params[:id]
  name = params[:name]
  salary = params[:salary]
  department = params[:department]
  {:success => true}.to_json
end

post '/removeEmployee' do
  id = params[:id]
  name = params[:name]
  salary = params[:salary]
  department = params[:department]
  {:success => true}.to_json
end

get '/findEmployee' do
  id = '4273'
  name = 'omar ayad'
  salary = 40000
  department = 'Artificial Intelligence'
  {:id => id, :name => name, :salary => salary, :department => department}.to_json
end
