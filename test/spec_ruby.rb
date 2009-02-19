require File.dirname(__FILE__) + "/spec_helper"

describe 'ruby stuff' do
  it 'scan' do
    str = "abcdfdfd1234fgdfgjldfgljj567dugfhgfgjfgso99999"
    str.scan(/\d{3,5}/).should == %w(1234 567 99999)
  end
  it 'regex from string' do
    reg_str = "\\.e"
    ("abc.def" =~ /#{reg_str}/).should == nil
  
    reg_str = ".e"
    ("abc.def" =~ /#{reg_str}/).should == 4
  
    reg_str = ".e"
    ("abc.def" =~ Regexp.escaped(reg_str)).should == nil
  
    reg_str = "d(.)"
    ("abc.def" =~ /d(.)/).should == 4
    ("abc.def" =~ Regexp.new(reg_str)).should == 4
    $1.should == 'e'
  end
  it 'gsub' do
    "abcdefgh".gsub(/b(cd)/,"x").should == "axefgh"
    #"abcdefgh".gsub(/b(cd)/,'\`x').should == "abxefgh"
    "abcdefgh".gsub(/(\w)(cd)/,'\1x').should == "abxefgh"
    "abc.def".gsub(/[.d]/,"").should == "abcef"
    "abc.def-ghi".gsub(/[.\-d]/,"").should == "abcefghi"
  end
end