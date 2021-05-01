import UIKit
import Dequeue
import Records

final class PerformerTableView: UITableView, DequeueableTableView, FetchedResultsTableView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register(cellType: PerformerTableViewCell.self, hasXib: true)
        backgroundColor = lightGray
    }
    
    func dequeue(at indexPath: IndexPath, for entity: Performer) -> PerformerTableViewCell {
        let configurator = PerformerTableViewCellConfigurator<PerformerViewModel>(
            titleKeyPath: \.title,
            subtitleKeyPath: \.subtitle
        )
        let cell: PerformerTableViewCell = dequeueCell(at: indexPath)
        configurator.configure(cell: cell, model: .init(entity))
        return cell
    }
}

extension PerformerTableView: FetchedResultsControllerDelegate {
    
    func updateCell(at indexPath: IndexPath, for entity: Performer) {
        _ = dequeue(at: indexPath, for: entity)
    }
}
