import Foundation
import CoreData

struct Database {
    
    static func populate(_ context: NSManagedObjectContext) throws {
        
        var event: Event?
        var party: Party?
        
        try JSONEvent.archive(in: context) { records in
            event = records.first
        }
        
        try JSONParty.archive(in: context) { records in
            party = records.first
        }
        
        try JSONPerformance.procure { decoded in
            // all performances are registering for the event starting "4/11/2017"
            // all performances and performers belong to the party named "School1"
            guard let event = event else {
                preconditionFailure()
            }
            try decoded.forEach { performance in
                guard let party = party else {
                    preconditionFailure()
                }
                let export = try performance.connect(event: event, party: party, context)
                _ = try export.record(in: context)
            }
        }
        
        try context.save()
    }
}
