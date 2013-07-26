describe "NSManageObjectContext(ext)" do

  before do
    @context = App.delegate.managedObjectContext
  end
  
  it "should have #<< and task is inserted to the context" do
    task = Task.new title:"task"
    @context.insertedObjects.containsObject(task).should == false
    @context << task
    @context.insertedObjects.containsObject(task).should == true
  end
  
end
