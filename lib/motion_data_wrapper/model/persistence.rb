module MotionDataWrapper
  class Model < NSManagedObject
    module Persistence

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def create(attributes={})
          begin
            model = create!(attributes)
          rescue MotionDataWrapper::RecordNotSaved
          end
          model
        end

        def create!(attributes={})
          model = new(attributes)
          model.save!
          model
        end

        def new(attributes={})
          context = BubbleWrap::App.delegate.managedObjectContext
          self.newWithContext(context, attributes)
        end

        def newWithoutContext(attributes={})
          self.newWithContext(nil, attributes)
        end

        alias :new_without_context :newWithoutContext

        def newWithContext(context, attributes={})
          alloc.initWithEntity(entity_description, insertIntoManagedObjectContext:context).tap do |model|
            model.instance_variable_set('@new_record', true)
            attributes.each do |keyPath, value|
              selector = "#{keyPath}=:"
              if model.respondsToSelector selector
                model.send(selector, value)
              else
                model.setValue(value, forKey:keyPath)
              end
            end
          end
        end

        alias :new_with_context :newWithContext

      end

      def awakeFromFetch
        after_fetch if respondsToSelector "after_fetch"
      end

      def awakeFromInsert
        after_fetch if respondsToSelector "after_fetch"
      end

      def destroy

        if context = managedObjectContext
          before_destroy_callback
          context.deleteObject(self)
          error = Pointer.new(:object)
          context.save(error)
          after_destroy_callback
        end

        @destroyed = true
        freeze
      end

      def destroyed?
        @destroyed || false
      end

      def new_record?
        @new_record || false
      end

      def persisted?
        !(new_record? || destroyed?)
      end

      def save
        begin
          save!
        rescue MotionDataWrapper::RecordNotSaved
          return false
        end
        true
      end

      def save!
        unless context = managedObjectContext
          context = BubbleWrap::App.delegate.managedObjectContext
          context.insertObject(self)
        end

        before_save_callback
        error = Pointer.new(:object)
        unless context.save(error)
# DEBUGME:
p error[0].description
          managedObjectContext.deleteObject(self)
          raise MotionDataWrapper::RecordNotSaved, self and return false
        end
        instance_variable_set('@new_record', false)
        after_save_callback

        true
      end

      private

      def before_save_callback
        before_save if respondsToSelector "before_save"
        @is_new_record = new_record?
        if @is_new_record
          before_create if respondsToSelector "before_create"
        else
          before_update if respondsToSelector "before_update"
        end
      end

      def after_save_callback
        if @is_new_record
          after_create if respondsToSelector "after_create"
        else
          after_update if respondsToSelector "after_update"
        end
        after_save if respondsToSelector "after_save"
      end

      def before_destroy_callback
        before_destroy if respondsToSelector "before_destroy"
      end

      def after_destroy_callback
        after_destroy if respondsToSelector "after_destroy"
      end

    end
  end
end
