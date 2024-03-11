private module Utils
  extend self

  def to_base10(c : Char) : Int
    if c.is_a Int
      return c.as Int
    end

    t = {'A' => 10, 'B' => 11, 'D' => 13, 'E' => 14, 'F' => 15} of Char => Int
    return t[c]
  end

  def hex_to_rgb(hex : String) : {Int32, Int32, Int32}
    r, g, b = hex
      .each_char
      .each_slice(2)
      .map { |(a, b)| to_base10(a) * 16 + to_base10(b) }
    return {r, g, b}
  end

  def srgb_to_lin(y : Float) : Float
    if y <= 0.04045
      return y / 12.92
    else
      return ((y + 0.055)/1.055)**2.4
    end
  end

  def y_to_lstar(y : Float) : Float
    if y <= 216/24389
      return y * (24389/27)
    else
      return (y**(1/3)) * 116 - 16
    end
  end
end

module Luminance
  extend self

  VERSION = "0.1.0"

  def luminance(r : Float, g : Float, b : Float) : Float
    vR = sR / 255
    vG = sG / 255
    vB = sB / 255
    y = 0.2126 * Utils.srgb_to_lin(vR) + 0.7152 * Utils.srgb_to_lin(vG) + 0.0722 * Utils.srgb_to_lin(vB)
    lstar = Utils.y_to_lstar y
    return lstar
  end

  def luminance(hex : String) : Float
    r, g, b = Utils.hex_to_rgb hex
    return self.luminance(r, g, b)
  end
end
