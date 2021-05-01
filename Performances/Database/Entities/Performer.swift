import CoreData
import Records

@objc(Performer)
public class Performer: NSManagedObject, Fetchable {
    @NSManaged public var dob: Date
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged private var gender: String
    @NSManaged public var party: Party
    @NSManaged public var performances: Set<Performance>?
}

// sourcery:inline:Performer.ManagedObjectQuery.stencil
public extension Performer {
    struct Query {
        public var dob: ClosedRange<Date>?
        public var firstName: StringParameter?
        public var lastName: StringParameter?
        public var party: Party?
        public var performances: Aggregate<Performance>?
        public var gender: Gender?

        public init(dob: ClosedRange<Date>? = nil, firstName: StringParameter? = nil, lastName: StringParameter? = nil, party: Party? = nil, performances: Aggregate<Performance>? = nil, gender: Gender? = nil) {
          self.dob = dob
          self.firstName = firstName
          self.lastName = lastName
          self.party = party
          self.performances = performances
          self.gender = gender
        }
    }
}

extension Performer.Query: QueryGenerator {

    public typealias Entity = Performer

    public var predicateRepresentation: NSCompoundPredicate? {
      var predicates = [NSPredicate]()
      if let predicate = dobPredicate() {
        predicates.append(predicate)
      }
      if let predicate = firstNamePredicate() {
        predicates.append(predicate)
      }
      if let predicate = lastNamePredicate() {
        predicates.append(predicate)
      }
      if let predicate = partyPredicate() {
        predicates.append(predicate)
      }
      if let predicate = performancesPredicate() {
        predicates.append(predicate)
      }
      if let predicate = genderPredicate() {
        predicates.append(predicate)
      }
      if predicates.count == 0 {
        return nil
      }
      return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    private func dobPredicate() -> NSPredicate? {
      guard let dob = dob else { return nil }
      return NSPredicate(format: "dob > %@ && dob < %@", dob.lowerBound as CVarArg, dob.upperBound as CVarArg)
    }
    private func firstNamePredicate() -> NSPredicate? {
      guard let firstName = firstName else { return nil }
      let value = "firstName" + " " + firstName.predicateFormat + " %@"
      return NSPredicate(format: value, firstName.candidate)
    }
    private func lastNamePredicate() -> NSPredicate? {
      guard let lastName = lastName else { return nil }
      let value = "lastName" + " " + lastName.predicateFormat + " %@"
      return NSPredicate(format: value, lastName.candidate)
    }
    private func partyPredicate() -> NSPredicate? {
      guard let party = party else { return nil }
      return NSPredicate(format: "party == %@", party as CVarArg)
    }
    private func performancesPredicate() -> NSPredicate? {
      guard let performances = performances else { return nil }
      return performances.predicate("performances")
    }
    private func genderPredicate() -> NSPredicate? {
      guard let gender = gender else { return nil }
      return NSPredicate(format: "gender == %@", gender.rawValue as CVarArg)
    }
}
// sourcery:end

extension Performer {
    
    public enum Gender: String {
        case male
        case female
    }
    
    public var gender_: Gender {
        get {
            return Gender(rawValue: gender)!
        }
        set {
            gender = newValue.rawValue
        }
    }
}

extension Performer {
    
    //sourcery:sourcerySkip
    var fullName: String {
        return firstName + " " + lastName
    }
    
    func matches(fullName otherFullName: String) -> Bool {
        return fullName == otherFullName
    }
    
    //sourcery:sourcerySkip
    var age: Int? {
        let components = Calendar.current.dateComponents([.year], from: dob, to: Date())
        return components.year
    }
}
