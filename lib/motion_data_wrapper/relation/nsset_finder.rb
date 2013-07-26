class NSSet

  def order(column, opts={})
    descriptors = []
    descriptors << NSSortDescriptor.sortDescriptorWithKey(column.to_s, ascending:opts.fetch(:ascending, true))
    self.sortedArrayUsingDescriptors descriptors
  end

end
