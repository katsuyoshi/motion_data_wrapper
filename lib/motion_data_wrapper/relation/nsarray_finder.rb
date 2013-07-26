class NSArray

  def order(column, opts={})
    descriptors = []
    descriptors << NSSortDescriptor.sortDescriptorWithKey(column.to_s, ascending:opts.fetch(:ascending, true))
    self.sortedArrayUsingDescriptors descriptors
  end

  def where(format, *args)
    predicate = NSPredicate.predicateWithFormat(format.gsub("?", "%@"), argumentArray:args)
    self.filteredArrayUsingPredicate predicate
  end

end
