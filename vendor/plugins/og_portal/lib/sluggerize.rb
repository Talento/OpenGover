# coding: utf-8
                           
String.class_eval do
    def sluggerize
      return "" if self.blank?
      value = self.gsub(/'+/i, "@") # initial commas to non ASCII char
      value.downcase!
      if value.encode
      value.gsub!("á", "a")
      value.gsub!("é", "e")
      value.gsub!("í", "i")
      value.gsub!("ó", "o")
      value.gsub!("ú", "u")
      value.gsub!("ñ", "n")
      value.gsub!("&", "")
      value.gsub!("acute;", "")
      value.gsub!("tilde;", "")
      value.gsub!(/<(.*?)>/, "")
      value.parameterize
        end
    end
end