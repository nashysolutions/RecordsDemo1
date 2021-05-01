import Foundation
import Records
import CoreData

struct JSONPerformance {
    
    let ability: String
    let group: String
    let performers: [JSONPerformer]
    
    struct Export {
        let ability: Performance.Ability
        let group: Performance.Group
        let performers: Set<Performer>
        let event: Event
        let aggregate: Aggregate<Performer>.Operator = .allMatching
    }
    
    private var ability_: Performance.Ability {
        guard let value = Performance.Ability(rawValue: ability) else {
            preconditionFailure()
        }
        return value
    }
    
    private var group_: Performance.Group {
        guard let value = Performance.Group(rawValue: group) else {
            preconditionFailure()
        }
        return value
    }
    
    func connect(event: Event, party: Party, _ context: NSManagedObjectContext) throws -> Export {
        let performers_: [Performer] = try performers.map { performer in
            let export = performer.connect(with: party)
            return try export.record(in: context)
        }
        return Export(
            ability: ability_,
            group: group_,
            performers: Set(performers_),
            event: event
        )
    }
}

extension JSONPerformance: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case ability = "Ability"
        case group = "Group"
        case performers = "Performers"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let ability = try values.decode(String.self, forKey: .ability)
        let group = try values.decode(String.self, forKey: .group)
        let performers = try values.decode([JSONPerformer].self, forKey: .performers)
        self.init(ability: ability, group: group, performers: performers)
    }
}

extension JSONPerformance.Export: Recordable {
    
    var primaryKey: Performance.Query {
        return .init(
            performers: performerRelationship,
            event: event,
            ability: ability,
            group: group
        )
    }
    
    private var performerRelationship: Aggregate<Performer> {
        return Aggregate<Performer>(aggregate, records: performers)
    }
    
    func update(record: Performance) {
        record.event = event
        record.performers = performers
        record.ability_ = ability
        record.group_ = group
    }
}

extension JSONPerformance: Procurable {
    
    static var json: URL {
        let bundle = Bundle(for: Performance.self)
        guard let value = bundle.url(forResource: "Performances", withExtension: "json") else {
            preconditionFailure()
        }
        return value
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dobDateFormatter)
        return decoder
    }
    
    static var dobDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yyyy"
        return dateFormatter
    }()
}
