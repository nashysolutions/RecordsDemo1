import Records
import CoreData

final class PerformerController<D: FetchedResultsControllerDelegate>: FetchedResultsController<D> where D.Record: Performer {
    
    var event: Event? {
        didSet {
            do {
                try reload()
            } catch {
                fatalError(message1)
            }
        }
    }
    
    var fullName: String?
    
    var gender: Performer.Gender?
    
    func updatePredicate(fullName: String?, gender: Performer.Gender? = nil) {
        self.fullName = fullName
        self.gender = gender
        do {
            try reload()
        } catch {
            fatalError(message1)
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
        var predicates = [NSPredicate]()
        if let event = event {
            predicates.append(NSPredicate(format: "ANY performances.event == %@", event))
        }
        if let fullName = fullName, fullName.isEmpty == false {
            predicates.append(contentsOf: buildPredicates(forFullName: fullName))
        }
        if let gender = gender {
            predicates.append(NSPredicate(format: "gender == %@", gender.rawValue))
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    private func buildPredicates(forFullName fullName: String) -> [NSPredicate] {
        var predicates = [NSPredicate]()
        let firstName: String
        let lastName: String?
        if let index = fullName.lastIndex(of: " ") {
            firstName = String(fullName[...fullName.index(before: index)])
            lastName = String(fullName[fullName.index(after: index)...])
        } else {
            firstName = fullName
            lastName = nil
        }
        predicates.append(NSPredicate(format: "firstName BEGINSWITH[cd] %@", firstName))
        if let lastName = lastName {
            predicates.append(NSPredicate(format: "lastName BEGINSWITH[cd] %@", lastName))
        }
        return predicates
    }
    
    override func sortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "firstName", ascending: true)]
    }
}
