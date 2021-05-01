import Foundation
import Records

struct JSONParty {
    let name: String
    let phone: String
    let email: String
    let type: String
}

extension JSONParty: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case phone = "Phone"
        case email = "Email"
        case type = "Type"
    }
}

extension JSONParty: Recordable {
    
    var primaryKey: Party.Query {
        return .init(
            email: .init(candidate: email),
            name: .init(candidate: name),
            phone: .init(candidate: phone),
            type: type_
        )
    }

    private var type_: Party.PartyType {
        guard let type = Party.PartyType(rawValue: type) else {
            preconditionFailure()
        }
        return type
    }
    
    func update(record: Party) {
        record.email = email
        record.name = name
        record.phone = phone
        record.type_ = type_
    }
}

extension JSONParty: Procurable {
    
    static var json: URL {
        let bundle = Bundle(for: Party.self)
        guard let value = bundle.url(forResource: "Parties", withExtension: "json") else {
            preconditionFailure()
        }
        return value
    }
}
