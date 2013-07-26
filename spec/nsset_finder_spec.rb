describe "NSSet(finder)" do

  before do
    # key must be String
    @set = NSSet.setWithArray [
              { "no" => 2 },
              { "no" => 1 },
              { "no" => 0 }
           ]
  end
  
  it "should be sorted with symbol and ascending true" do
    @set.order(:no).map{|e| e["no"]}.should == [0, 1, 2]
  end
  
  it "should be sorted with string and ascending true" do
    @set.order("no").map{|e| e["no"]}.should == [0, 1, 2]
  end
  
  it "should be sorted with symbol and ascending false" do
    @set.order(:no, ascending:false).map{|e| e["no"]}.should == [2, 1, 0]
  end
    
end
