describe "NSSet(finder)" do

  before do
    # key must be String
    @set = NSSet.setWithArray [
              { "index" => 2 },
              { "index" => 1 },
              { "index" => 0 }
           ]
  end
  
  it "should be sorted with symbol and ascending true" do
    @set.order(:index).map{|e| e["index"]}.should == [0, 1, 2]
  end
  
  it "should be sorted with string and ascending true" do
    @set.order("index").map{|e| e["index"]}.should == [0, 1, 2]
  end
  
  it "should be sorted with symbol and ascending false" do
    @set.order(:index, ascending:false).map{|e| e["index"]}.should == [2, 1, 0]
  end
    
  it "should be filtered and return index 1 " do
    @set.where("index = ?", 1).anyObject["index"].should == 1
  end
  
end
