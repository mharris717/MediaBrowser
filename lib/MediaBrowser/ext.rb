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

def all_dirs_recursive(dir)
  dir.split("/")[1..-1].inject([]) do |paths,dir|
    paths + ["#{paths[-1]}/#{dir}"]
  end
end

def mkdir_if(dir)
  FileUtils.mkdir(dir) unless FileTest.exists?(dir)
end

def mkdir_recursive(dir)
  all_dirs_recursive(dir).each do |dir|
    mkdir_if(dir)
  end
end