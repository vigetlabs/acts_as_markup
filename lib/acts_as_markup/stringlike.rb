# This mixin allows our markup objects (like RDiscount or RedCloth) to have
# all the normal string methods that are available.
module Stringlike
  def method_missing(method, *params)
    self.to_s.send(method, *params)
  end
end
