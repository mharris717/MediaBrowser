require File.dirname(__FILE__) + "/spec_helper"

describe StoreHash do
  before(:each) do
    @calls = Hash.new { |h,k| h[k] = 0 }
    @h = StoreHash.new(:store_type => 'stuff') do |k|
      @calls[k] += 1
      "#{k}_result"
    end
    CreateStoreTable.run!
  end
  it 'smoke' do
    2.should == 2
    @h['abc']
  end
  it 'access' do
    @h['abc'].should == 'abc_result'
  end
  it 'access count' do
    @h['abc']
    @calls['abc'].should == 1
  end
  it 'multiple calls should only call block once' do
    @h['abc']; @h['abc']
    @calls['abc'].should == 1
  end
  after(:each) do
    ActiveRecord::Base.clear_all_connections!
    #FileUtils.rm(StoreRow.db_path)
  end
end