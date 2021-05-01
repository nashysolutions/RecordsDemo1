import Foundation
import Records

struct JSONPerformer {
    
    let firstName: String
    let lastName: String
    let dob: Date
    let gender: String
    
    struct Export {
        let firstName: String
        let lastName: String
        let dob: Date
        let party: Party
        let gender: Performer.Gender
    }
    
    private var gender_: Performer.Gender {
        guard let value = Performer.Gender(rawValue: gender.lowercased()) else {
            preconditionFailure()
        }
        return value
    }
    
    func connect(with party: Party) -> Export {
        return Export(
            firstName: firstName,
            lastName: lastName,
            dob: dob,
            party: party,
            gender: gender_
        )
    }
}

extension JSONPerformer: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case firstName = "First Name"
        case lastName = "Last Name"
        case dob = "D.O.B"
        case gender = "Gender"
    }
}

extension JSONPerformer.Export: Recordable {
    
    /// There may be performers with identical details between parties and they may be the same person.
    /// Performers may change parties over time and we wouldn't know.
    /// Or performers may have the same details by coinsidence.
    /// So have decided to create a single record per performer per party.
    var primaryKey: Performer.Query {
        let lower = dob.oneDayEarlier
        let upper = dob.oneDayLater
        return Performer.Query(
            dob: lower...upper,
            firstName: .init(candidate: firstName),
            lastName: .init(candidate: lastName),
            party: party,
            gender: gender
        )
    }
    
    func update(record: Performer) {
        record.party = party
        record.dob = dob
        record.firstName = firstName
        record.lastName = lastName
        record.gender_ = gender
    }
}
