# coding:utf-8
require 'sinatra'
require 'sinatra/reloader' 
require 'active_record'
require 'mysql2'
require 'sinatra'

#外部との通信を許可
set :environment, :production

# DB設定ファイルの読み込み
ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection('development')

ActiveRecord::Base.logger = Logger.new("./log/production.log")
ActiveRecord::Base.logger.level = 0

#active_recordのタイムゾーンを日本時間に設定
Time.zone_default =  Time.find_zone! 'Tokyo'

configure do
  # logging is enabled by default in classic style applications,
  # so `enable :logging` is not needed
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end




class Practices < ActiveRecord::Base
end

class Time_Format

  def today_time
    require 'date'
    day = DateTime.now
    today = day.strftime("%m月%d日")

     week = ["(日)","(月)","(火)","(水)","(木)","(金)","(土)"]

    for i in 0..6 do
      t_week = week[i] if day.strftime("%w") == i.to_s
    end 

    t_day = today+t_week.gsub("(","（").gsub(")","）")
    #半角括弧を全角括弧に変換 
  end
end

get '/Monday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（月）%'")
  practices.to_json(:root => false)
end

get '/Tuesday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（火）%'")
  practices.to_json(:root => false)
end

get '/Wednesday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（水）%'")
  practices.to_json(:root => false)
end

get '/Thirsday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（木）%'")
  practices.to_json(:root => false)
end

get '/Friday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（金）%'")
  practices.to_json(:root => false)
end

get '/Saturday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（土）%'")
  practices.to_json(:root => false)
end

get '/Sunday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（日）%'")
  practices.to_json(:root => false)
end

get '/holiday_checker.json' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.select("date,period").where("date = ?",t_day).where("period = ?","0")
  practices.to_json(:root => false)
end

get '/holiday_checker.xml' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :xml, :charset => 'utf-8'
  practices = Practices.select("date,period").where("date = ?",t_day).where("period = ?","0")
  practices.to_xml(:root => false)
end

get '/available_room.json' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.select("id,week_id,date,period,room").where("date = ?",t_day).where("band IS NULL or band = ?",'')
  practices.to_json(:root => false)
end

get '/available_room.xml' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :xml, :charset => 'utf-8'
  practices = Practices.select("id,week_id,date,period,room").where("date = ?",t_day).where("band IS NULL or band = ?", '')
  practices.to_xml(:root => false)
end