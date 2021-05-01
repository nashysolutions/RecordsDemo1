import UIKit

final class PerformanceTableViewHandler: NSObject {
    
    typealias PerformanceConsumer = (Performance) -> Void
    
    var didSelect: PerformanceConsumer?
    
    private let perormanceController: PerformanceController<PerformancesTableView>
    
    init(_ perormanceController: PerformanceController<PerformancesTableView>) {
        self.perormanceController = perormanceController
    }
}

extension PerformanceTableViewHandler: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return perormanceController.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return perormanceController.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return perormanceController.fetchedResultsController.sections?[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? PerformancesTableView else {
            fatalError("Muts have PerformancesTableView here.")
        }
        let entity = perormanceController.fetchedResultsController.object(at: indexPath)
        return tableView.dequeue(at: indexPath, for: entity)
    }
}

extension PerformanceTableViewHandler: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = Storage.sharedInstance.persistentContainer.viewContext
        let entity = perormanceController.fetchedResultsController.object(at: indexPath)
        context.delete(entity)
        do {
            try context.save()
        } catch {
            fatalError(message1)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = perormanceController.fetchedResultsController.object(at: indexPath)
        didSelect?(entity)
    }
}
