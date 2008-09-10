module Stringlike
  def method_missing(method, *params)
    self.to_s.send(method, *params)
  end
end