require 'rubygems'
require 'activerecord'

class CreateMediaTable < ActiveRecord::Migration
  def self.up
    create_table :media do |t|
      t.string :series
      t.integer :season
      t.integer :episode_num
      t.string :episode_title
      t.string :path
      t.timestamps
    end
  end
  def self.run!
    MediaRow.find(:first)
  rescue 
    migrate(:up)
  end
end

class MediaRow < ActiveRecord::Base
  set_table_name 'media'
end

puts "establishing conn to media"
ActiveRecord::Base.establish_connection(:adapter => 'mysql', :host => 'localhost', :database => 'media')
CreateMediaTable.run!
