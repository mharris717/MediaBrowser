require 'rubygems'
# require 'socket'
# 
# s = UDPSocket.open
# # s.connect("127.0.0.1",99719)
# puts s.send("GET /description",0,"127.0.0.1",99719)
# puts 'done'

require 'UPnP/service/content_directory'

u = UPnP::Service::ContentDirectory.new(nil,nil)
puts u.Browse('0','BrowseDirectChildren','',0,99,'')[1]
puts u.Browse('1','BrowseDirectChildren','',0,99,'')[1]
puts u.Browse('4','BrowseDirectChildren','',0,99,'')[1]