require 'rubygems'
require 'activerecord'

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

class CreateStoreTable < ActiveRecord::Migration
  def self.up
    create_table :store_rows do |t|
      t.column :store_type, :string
      t.column :key, :string
      t.column :result, :binary
    end
  end
  def self.run!
    StoreRow.find(:first)
  rescue 
    migrate(:up)
  end
end

class StoreRow < ActiveRecord::Base
  def self.get_result(store_type,key)
    res = find(:first, :conditions => {:store_type => store_type, :key => key})
    res ? Marshal.load(res.result) : nil
  end
  def self.db_path
    File.expand_path(File.dirname(__FILE__) + "/store.sqlite3")
  end
end

puts "establishing conn to #{StoreRow.db_path}"
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => StoreRow.db_path, :timeout => 5000)
CreateStoreTable.run!

class StoreHash
  include FromHash
  attr_accessor :store_type, :gen_blk
  def initialize(ops,&b)
    from_hash(ops)
    self.gen_blk = b if block_given?
  end
  def from_store(k)
    StoreRow.get_result(store_type,k)
  end
  def [](k)
    res = from_store(k)
    return res if res
    res = gen_blk.call(k)
    StoreRow.new(:store_type => store_type, :key => k, :result => Marshal.dump(res)).save!
    res
  end
end

class Class
  def store_method(method,key_method,&b)
    define_method(method) do
      if instance_variable_get("@#{method}")
        instance_variable_get("@#{method}")
      else
        h = StoreHash.new(:store_type => method) do
          instance_eval(&b)
        end
        k = send(key_method)
        res = h[k]
        instance_variable_set("@#{method}",res)
        res
      end
    end
  end
end