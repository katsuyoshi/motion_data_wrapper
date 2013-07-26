# -*- coding: utf-8 -*-
describe "finder methods of MotionDataWrapper::Model with empty data" do

  after do
    clean_core_data
  end
  
  it "should get empty array" do
    Task.all.should == []
  end
  
  it "should get empty array with order" do
    Task.order(:title).all.should == []
  end
  
  it "should get empty array with order with option" do
    Task.order(:title, ascending:false).all.should == []
  end
  
end
