import CoreData

final class Storage {
    
    let persistentContainer: NSPersistentContainer
    
    static let sharedInstance = Storage()
    
    private init() {
        do {
            persistentContainer = try StackBuilder().load()
        } catch {
            fatalError(message1)
        }
    }
}

private final class StackBuilder {
    
    private let modelName = "Model"
    
    public enum Configuration {
        case temporary
        case permanent
    }
    
    let configuration: Configuration
    
    public init(_ configuration: Configuration = .permanent) {
        self.configuration = configuration
    }
    
    public func load() throws -> NSPersistentContainer {
        var errors = [Error]()
        let persistentContainer = PersistentContainer(name: modelName)
        persistentContainer.persistentStoreDescriptions = [description(for: configuration)]
        persistentContainer.loadPersistentStores { (value, error) in
            if error != nil {
                errors.append(error!)
            }
        }
        if errors.count > 0 {
            throw errors.first!
        }
        return persistentContainer as NSPersistentContainer
    }
    
    private func description(for configuration: Configuration) -> NSPersistentStoreDescription {
        let desc = NSPersistentStoreDescription(url: storeURL)
        switch configuration {
        case .temporary:
            desc.type = NSInMemoryStoreType
        case .permanent:
            desc.shouldInferMappingModelAutomatically = true
            desc.shouldMigrateStoreAutomatically = true
            desc.type = NSSQLiteStoreType
        }
        return desc
    }
    
    private var storeURL: URL {
        let storeDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return storeDirectory.appendingPathComponent(modelName + ".sqlite")
    }
}

private final class PersistentContainer: NSPersistentContainer {
    // By default, NSPersistentContainer checks the main bundle for the model file.
    // But if we subclass like this, it will change it's default behaviour. Instead, it will look in the bundle that contains this subclass.
}
