describe "NSArray(finder)" do

  before do
    # key must be String
    @array = [
                { "index" => 2 },
                { "index" => 1 },
                { "index" => 0 }
             ]
  end
  
  it "should be sorted with symbol and ascending true" do
    @array.order(:index).map{|e| e["index"]}.should == [0, 1, 2]
  end
  
  it "should be sorted with string and ascending true" do
    @array.order("index").map{|e| e["index"]}.should == [0, 1, 2]
  end
  
  it "should be sorted with symbol and ascending false" do
    @array.order(:index, ascending:false).map{|e| e["index"]}.should == [2, 1, 0]
  end
    
  it "should be filtered and return index 1 " do
    @array.where("index = ?", 1).first["index"].should == 1
  end
  
end
