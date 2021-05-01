import Foundation
import Records

struct JSONEvent {
    let startDate: Date
}

extension JSONEvent: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case startDate = "StartDate"
    }
}

extension JSONEvent: Recordable {
    
    var primaryKey: Event.Query {
        let lower = startDate.oneDayEarlier
        let upper = startDate.oneDayLater
        return Event.Query(startDate: lower...upper)
    }
    
    func update(record: Event) {
        record.startDate = startDate
    }
}

extension JSONEvent: Procurable {

    static var json: URL {
        let bundle = Bundle(for: Event.self)
        guard let value = bundle.url(forResource: "Events", withExtension: "json") else {
            preconditionFailure()
        }
        return value
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(eventDateFormatter)
        return decoder
    }
    
    private static var eventDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yyyy"
        return dateFormatter
    }()
}
