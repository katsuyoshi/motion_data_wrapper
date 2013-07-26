class Task < MotionDataWrapper::Model

  attr_accessor :frame
  
  def frame= frame
    @frame = frame
    self.frame_string = NSStringFromCGRect frame
  end
    
end
