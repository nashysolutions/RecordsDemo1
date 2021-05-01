import UIKit
import CoreData

final class EventTableViewHandler: NSObject {
    
    typealias EventConsumer = (Event) -> Void
    
    var selectEvent: EventConsumer?
    
    private let eventController: EventController<EventsTableView>
    
    init(_ eventController: EventController<EventsTableView>) {
        self.eventController = eventController
    }
}

extension EventTableViewHandler: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventController.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventController.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventController.fetchedResultsController.sections?[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? EventsTableView else {
            fatalError("Must have EventTableView here.")
        }
        let entity = eventController.fetchedResultsController.object(at: indexPath)
        return tableView.dequeue(at: indexPath, for: entity)
    }
}

extension EventTableViewHandler: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = Storage.sharedInstance.persistentContainer.viewContext
        let entity = eventController.fetchedResultsController.object(at: indexPath)
        context.delete(entity)
        do {
            try context.save()
        } catch {
            fatalError(message1)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = eventController.fetchedResultsController.object(at: indexPath)
        if entity.performances?.count == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            selectEvent?(entity)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return nil
    }
}
