# -*- coding: utf-8 -*-
describe MotionDataWrapper::Model do

  before do
    @delegate = App.delegate
  end

  after do
    clean_core_data
  end
  
  it "should create task" do
    Task.create title:"Task1"
    Task.all.size.should == 1
  end
  
  it "should be stored to app support dir" do
    # prepare directory
    manager = NSFileManager.defaultManager
    dir = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, true)[0]
    manager.createDirectoryAtPath dir, withIntermediateDirectories:true, attributes:nil, error:nil

    # set store path
    path = File.join(dir, "#{@delegate.sqlite_store_name}.sqlite")
    @delegate.sqlite_path = path

    # write a data
    Task.create title:"Task1"

    manager.fileExistsAtPath(path).should == true
  end
  
  it "should have context using #new" do
    task = Task.new title:"Task"
    task.managedObjectContext.should.not == nil
  end
  
  it "should have context using #new_with_context" do
    context = App.delegate.managedObjectContext
    task = Task.new_with_context context, title:"Task"
    task.managedObjectContext.should.not == nil
  end
  
  it "should not have context using #newWithoutContext" do
    task = Task.newWithoutContext title:"Task"
    task.managedObjectContext.should == nil
  end
  
  it "should not have context using #new_without_context" do
    task = Task.new_without_context title:"Task"
    task.managedObjectContext.should == nil
  end
  
  it "should not create a task because title was not seted. and you'll see a reason which help your debugging" do
    Task.new.save.should == false
  end
  
  
end
