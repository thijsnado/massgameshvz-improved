module Codeinator
  
  def self.format_code(code)
    if code && code.respond_to?(:strip)
      code = code.strip
      code = code.gsub(/[oO0]/, 'o')
      code = code.upcase
    end
    return code
  end
  
end