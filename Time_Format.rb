# coding:utf-8
require 'date'

class Time_Format

  def initialize(month, day)
    @today = DateTime.now
    @date = DateTime.new(@today.strftime('%Y').to_i, month.to_i, day.to_i)
    @week = ["(日)","(月)","(火)","(水)","(木)","(金)","(土)"]
  end

  def today_time
    @detected_date = @date.strftime('%m月%d日')

    for i in 0..6 do
      @t_week = @week[i] if @date.strftime("%w") == i.to_s
    end

    @t_day = @detected_date + @t_week.gsub("(","（").gsub(")","）")
    #半角括弧を全角括弧に変換
  end
end
