class Task < MotionDataWrapper::Model

  attr_accessor :frame
  
  def after_fetch
    if self.frame_string
      @frame = CGRectFromString self.frame_string
    else
      CGRectZero
    end
  end
  
  def frame= frame
    @frame = frame
    self.frame_string = NSStringFromCGRect frame
  end
    
end
