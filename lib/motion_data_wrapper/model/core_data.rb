module MotionDataWrapper
  class Model < NSManagedObject
    module CoreData

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def entity_description
          @_metadata ||= BubbleWrap::App.delegate.managedObjectModel.entitiesByName[name]
        end

      end

    end
  end
end
