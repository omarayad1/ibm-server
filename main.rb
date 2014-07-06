require 'sinatra'
require 'json'

jsondb_db = JSON.parse(ENV['VCAP_SERVICES'])["SQLDB-1.0"]
  credentials = jsondb_db.first["credentials"]
  host = credentials["host"]
  username = credentials["username"]
  password = credentials["password"]
  database = credentials["db"]
  port = credentials["port"]
  dsn = "DRIVER={IBM DB2 ODBC DRIVER};DATABASE="+database+";HOSTNAME="+host+";PORT="+port.to_s()+";PROTOCOL=TCPIP;UID="+username+";PWD="+password+";"

get '/' do
  'nothing here please see the API documentation'
end

get '/connectDB' do
  if conn = IBM_DB.connect(dsn, '', '')
    tablename = "BLUEMIX.EMPLOYEES"
    sql = "CREATE TABLE " + tablename + " (FIRSTNAME VARCHAR(20), LASTNAME VARCHAR(20), EMPNO INT)"
    if stmt = IBM_DB.exec(conn, sql)
       total = total + sql + "<BR&gt;<BR&gt;\n"
    else
      out = "Statement execution failed: #{IBM_DB.stmt_errormsg}"
      total = total + out + "<BR&gt;\n"
    end
  end
end

post '/createEmployee' do
  name = params[:name]
  salary = params[:salary]
  department = params[:department]
  {:success => true }.to_json
end

get '/findEmployee' do
  name = 'omar ayad'
  salary = 40000
  department = 'Artificial Intelligence'
  {:name => name, :salary => salary, :department => department}.to_json
end
