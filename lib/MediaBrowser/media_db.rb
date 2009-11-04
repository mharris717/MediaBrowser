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
  def self.save_media(m)
    find_or_create_by_path(:series => m.show_title, :season => m.season, :episode_num => m.episode_num, :path => m.path)
  end
end

puts "establishing conn to media"
ActiveRecord::Base.establish_connection(:adapter => 'mysql', :host => 'localhost', :database => 'media')
CreateMediaTable.run!
