module MediaBrowser
  class Season
    attr_accessor :media, :season, :series
    include FromHash
    fattr(:name) { "#{series.name} Season #{season}" }
    def children
      media
    end
    def to_s
      name
    end
    def each(&b)
      children.each(&b)
    end
  end
end