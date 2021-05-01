import UIKit

final class PerformerTableViewHandler: NSObject {
    
    typealias PerformerConsumer = (Performer) -> Void
    
    var didSelect: PerformerConsumer?
    
    var animationsEnabled: Bool = true
    
    var selectedPerformer: Performer?
    
    var indexPathForSelectedRow: IndexPath? {
        if let performer = selectedPerformer {
            return indexPath(for: performer)
        }
        return nil
    }
    
    private let performerController: PerformerController<PerformerTableView>
    
    init(_ performerController: PerformerController<PerformerTableView>) {
        self.performerController = performerController
    }
    
    func deselectSelected() -> IndexPath? {
        if let indexPath = indexPathForSelectedRow {
            selectedPerformer = nil
            return indexPath
        }
        return nil
    }
    
    func indexPath(for performer: Performer) -> IndexPath? {
        return performerController.fetchedResultsController.indexPath(forObject: performer)
    }
}

extension PerformerTableViewHandler: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return performerController.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performerController.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return performerController.fetchedResultsController.sections?[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? PerformerTableView else {
            fatalError("Must have PerformerTableView here.")
        }
        let entity = performerController.fetchedResultsController.object(at: indexPath)
        return tableView.dequeue(at: indexPath, for: entity)
    }
}

extension PerformerTableViewHandler: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let entity = performerController.fetchedResultsController.object(at: indexPath)
        guard let cell = cell as? PerformerTableViewCell else {
            fatalError("Must have PerformerTableViewCell here.")
        }
        cell.setSelected(entity == selectedPerformer, animated: false)
        if animationsEnabled {
            cell.animate()
        }
    }
    
    // A performance must have a minimum of one performer. This rule is set in Model.xcdatamodelid file. So likely error will throw here.
    // Further rules apply. See Performance.swift performValidation()
    // Build more UI to handle these corner cases.
    //  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //    let context = Storage.sharedInstance.persistentContainer.viewContext
    //    let entity = performerController.fetchedResultsController.object(at: indexPath)
    //    context.delete(entity)
    //    do {
    //      try context.save()
    //    } catch {
    //      fatalError(message1)
    //    }
    //  }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = performerController.fetchedResultsController.object(at: indexPath)
        selectedPerformer = entity
        didSelect?(entity)
    }
}
