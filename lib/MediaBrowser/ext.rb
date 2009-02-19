module FromHash
  def from_hash(ops)
    ops.each do |k,v|
      send("#{k}=",v)
    end
  end
  def initialize(ops={})
    from_hash(ops)
  end
end

class String
  def without_junk_chars
    gsub(/[ \-_.]/," ")
  end
end

module Enumerable
  def group_by
    res = Hash.new { |h,k| h[k] = [] }
    each { |x| res[yield(x)] << x }
    res
  end
end