import CoreData
import Records

@objc(Event)
public class Event: NSManagedObject, Fetchable {
    @NSManaged public var startDate: Date
    @NSManaged public var performances: Set<Performance>?
}

// sourcery:inline:Event.ManagedObjectQuery.stencil
public extension Event {
    struct Query {
        public var startDate: ClosedRange<Date>?
        public var performances: Aggregate<Performance>?

        public init(startDate: ClosedRange<Date>? = nil, performances: Aggregate<Performance>? = nil) {
          self.startDate = startDate
          self.performances = performances
        }
    }
}

extension Event.Query: QueryGenerator {

    public typealias Entity = Event

    public var predicateRepresentation: NSCompoundPredicate? {
      var predicates = [NSPredicate]()
      if let predicate = startDatePredicate() {
        predicates.append(predicate)
      }
      if let predicate = performancesPredicate() {
        predicates.append(predicate)
      }
      if predicates.count == 0 {
        return nil
      }
      return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    private func startDatePredicate() -> NSPredicate? {
      guard let startDate = startDate else { return nil }
      return NSPredicate(format: "startDate > %@ && startDate < %@", startDate.lowerBound as CVarArg, startDate.upperBound as CVarArg)
    }
    private func performancesPredicate() -> NSPredicate? {
      guard let performances = performances else { return nil }
      return performances.predicate("performances")
    }
}
// sourcery:end

public extension Event {
    /// sourcery:sourcerySkip
    var performerCount: Int {
        var uniquePerformers: Set<Performer> = []
        performances?.forEach({ (performance) in
            _ = performance.performers.filter({ (performer) -> Bool in
                if uniquePerformers.contains(performer) {
                    return false
                } else {
                    uniquePerformers.insert(performer)
                    return true
                }
            })
        })
        return uniquePerformers.count
    }
}
