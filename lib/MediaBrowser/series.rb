module MediaBrowser
  class Series
    attr_accessor :name, :media
    include FromHash
    fattr(:children) do
      media.group_by { |x| x.season }.map { |k,x| Season.new(:season => k, :media => x, :series => self) }
    end
    def to_s
      name
    end
    def each(&b)
      children.each(&b)
    end
  end
end