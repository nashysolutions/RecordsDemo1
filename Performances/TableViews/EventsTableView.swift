import UIKit
import Dequeue
import Records

final class EventsTableView: UITableView, DequeueableTableView, FetchedResultsTableView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register(cellType: EventTableViewCell.self, hasXib: false)
    }
    
    func dequeue(at indexPath: IndexPath, for entity: Event) -> EventTableViewCell {
        let configurator = EventTableViewCellConfigurator<EventViewModel>(
            titleKeyPath: \.title,
            subtitleKeyPath: \.subtitle,
            accessoryTypeKeyPath: \.accessoryType
        )
        let cell: EventTableViewCell = dequeueCell(at: indexPath)
        configurator.configure(cell: cell, model: .init(entity))
        return cell
    }
}

extension EventsTableView: FetchedResultsControllerDelegate {
    
    func updateCell(at indexPath: IndexPath, for entity: Event) {
        _ = dequeue(at: indexPath, for: entity)
    }
}
