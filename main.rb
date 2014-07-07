require 'sinatra'
require 'json'
require 'ibm_db'

allServices = JSON.parse(ENV['VCAP_SERVICES'])
sqldbServiceKey = ""
allServices.keys.each { |key|
  # Look for the service key that matches the SQLDB service name we're looking for
  if key.to_s.downcase.include? "sqldb"
  sqldbServiceKey = key.to_s
  end
}
if sqldbServiceKey != ""
  sqldb = allServices[sqldbServiceKey]
  credentials = sqldb.first["credentials"]
  host = credentials['host']
  username = credentials['username']
  password = credentials['password']
  database = credentials['db']
  port = credentials['port']
  dsn = "DRIVER={IBM DB2 ODBC DRIVER};DATABASE="+database+";HOSTNAME="+host+";PORT="+port.to_s()+";PROTOCOL=TCPIP;UID="+username+";PWD="+password+";"
end

get '/' do
  if conn = IBM_DB.connect(dsn, '', '')
    tablename = "EMPLOYEES"
    IBM_DB.exec(conn, "DROP TABLE "+tablename)
    sql = "CREATE TABLE " + tablename + " (NAME VARCHAR(50),DEPARTMENT VARCHAR(20), SALARY INT, EMPNO INT NOT NULL PRIMARY KEY)"
    if IBM_DB.exec(conn, sql)
      {:success => true}.to_json
    else
      {:success => false}.to_json
    end
  end
end

post '/addEmployee' do
  id = params[:id]
  name = params[:name]
  salary = params[:salary]
  department = params[:department]
  sql = "INSERT INTO EMPLOYEES (NAME,DEPARTMENT,SALARY,EMPNO) VALUES ('" + name + "','" + department + "','" + salary.to_s + "','" + id.to_s + "');"
  conn = IBM_DB.connect(dsn, '', '')
  if IBM_DB.exec(conn, sql)
    {:success => true, :id => id}.to_json
  else
    {:success => false}.to_json
  end
end

post '/removeEmployee' do
  id = params[:id]
  name = params[:name]
  sql = "DELETE FROM EMPLOYEES WHERE EMPNO=? " + id + ";"
  IBM_DB.connect(dsn, '', '')
  if IBM_DB.prepare(conn, sql)
    {:success => true, :id => id}.to_json
  else
    {:success => false, :id => id}.to_json
  end
end

post '/findEmployee' do
  id = params[:id]
  name = params[:name]
  department = params[:department]
  sql = "SELECT * FROM EMPLOYEES WHERE EMPNO= " + id.to_s + ";"
  {:id => id, :name => name, :department => department}.to_json
end
