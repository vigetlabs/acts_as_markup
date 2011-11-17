class BlueClothText < BlueCloth
  include Stringlike

  def initialize(string, options = BlueCloth::DEFAULT_OPTIONS)
    @string = string
    super
  end
  
  def to_s
    @string
  end
  
  def blank?
    @string.blank?
  end
end