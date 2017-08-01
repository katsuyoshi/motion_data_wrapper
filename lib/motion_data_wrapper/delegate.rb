module MotionDataWrapper
  module Delegate

    def managedObjectContext
      @managedObjectContext ||= begin
        error_ptr = Pointer.new(:object)
        unless persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: sqlite_url, options: persistent_store_options, error: error_ptr)
          raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
        end

        context = NSManagedObjectContext.alloc.init
        context.persistentStoreCoordinator = persistentStoreCoordinator

        context
      end
    end

    def managedObjectModel
      @managedObjectModel ||= begin
        model = NSManagedObjectModel.mergedModelFromBundles([NSBundle.mainBundle]).mutableCopy

        model.entities.each do |entity|
          begin
            # クラス名がImageだとCoreDataが下エラーを出して扱えない
            #　'NSInternalInconsistencyException', reason: '"Image" is not a subclass of NSManagedObject.'
            # モデルクラスでMDを後につけたクラスを使用する様にし、サブクラスで元のクラスにして回避する
            # class ImageMD < MotionDataWrapper::Model  ... end
            # class Image < ImageMD
            name = entity.name
            case name
            when "Image"
              name = name + "MD"
            end
            Kernel.const_get(name)
            entity.setManagedObjectClassName(name)
          rescue NameError
            entity.setManagedObjectClassName("Model")
          end
        end

        model
      end
    end

    def persistentStoreCoordinator
      @coordinator ||= NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(managedObjectModel)
    end

    def sqlite_store_name
      BubbleWrap::App.name
    end

    def sqlite_url
      if Object.const_defined?("UIApplication")
        NSURL.fileURLWithPath(sqlite_path)
      else
        error_ptr = Pointer.new(:object)
        unless support_dir = NSFileManager.defaultManager.URLForDirectory(NSApplicationSupportDirectory, inDomain: NSUserDomainMask, appropriateForURL: nil, create: true, error: error_ptr)
          raise "error creating application support folder: #{error_ptr[0]}"
        end
        support_dir = support_dir.URLByAppendingPathComponent("/#{BubbleWrap::App.name}")
        Dir.mkdir(support_dir.path) unless Dir.exists?(support_dir.path)
        support_dir.URLByAppendingPathComponent("#{sqlite_store_name}.sqlite")
      end
    end

    def sqlite_path
      @sqlite_path || File.join(BubbleWrap::App.documents_path, "#{sqlite_store_name}.sqlite")
    end

    def sqlite_path= path
      @sqlite_path = path
    end

    def persistent_store_options
      { NSMigratePersistentStoresAutomaticallyOption => true, NSInferMappingModelAutomaticallyOption => true }
    end

  end
end
