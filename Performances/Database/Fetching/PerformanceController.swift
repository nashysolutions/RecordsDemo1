import Foundation
import Records

final class PerformanceController<D: FetchedResultsControllerDelegate>: FetchedResultsController<D> where D.Record: Performance {
    
    var event: Event? {
        didSet {
            do {
                try reload()
            } catch {
                fatalError(message1)
            }
        }
    }
    
    convenience init() {
        do {
            try self.init(context: Storage.sharedInstance.persistentContainer.viewContext)
        } catch {
            fatalError(message1)
        }
    }
    
    override func predicate() -> NSCompoundPredicate {
        guard let event = event else {
            return super.predicate()
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "event == %@", event)])
    }

    private let sectionName = "group"

    override func sortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: sectionName, ascending: true)]
    }

    override func sectionNameKeyPath() -> String? {
        return sectionName
    }
}
