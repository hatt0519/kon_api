class Word

  def include_period?(word)
    word.include?("限")
  end


  def self.integer_string?(word)
    begin
      Integer(word)
      true
    rescue ArgumentError
      false
    end
  end

end
