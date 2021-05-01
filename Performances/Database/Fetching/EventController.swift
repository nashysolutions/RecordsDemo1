import Records
import CoreData

final class EventController<D: FetchedResultsControllerDelegate>: FetchedResultsController<D> where D.Record: Event {
    
    convenience init() {
        do {
            try self.init(context: Storage.sharedInstance.persistentContainer.viewContext)
        } catch {
            fatalError(message1)
        }
    }
    
    override func sortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "startDate", ascending: true)]
    }
}
