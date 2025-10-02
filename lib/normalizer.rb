require 'nkf'

module Normalizer
  def self.normalize_name(str)
    NKF.nkf('-w -Z1 --hiragana', str.to_s)
  end
end
