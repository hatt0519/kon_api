# coding:utf-8
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
  def nextday_time
      require 'date'
      day = DateTime.now
      next_day = day + 1
      next_day_format = day.strftime("%m月%d日")

      week = ["(日)","(月)","(火)","(水)","(木)","(金)","(土)"]

      for i in 0..6 do
        n_week = week[i] if next_day.strftime("%w") == i.to_s
      end 

      n_day = next_day_format+n_week.gsub("(","（").gsub(")","）")
      #半角括弧を全角括弧に変換 
  end
end