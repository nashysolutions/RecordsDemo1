import UIKit
import Dequeue
import Records

class PerformancesTableView: UITableView, DequeueableTableView, FetchedResultsTableView {
    
    typealias Special = () -> Set<Performer>?
    
    var highlightedPerformers: Special?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register(cellType: PerformanceTableViewCell.self, hasXib: false)
    }
    
    func dequeue(at indexPath: IndexPath, for entity: Performance) -> PerformanceTableViewCell {
        let configurator = PerformanceTableViewCellConfigurator<PerformanceViewModel>(
            titleKeyPath: \.title,
            subtitleKeyPath: \.subtitle
        )
        let performers = highlightedPerformers?()
        let cell: PerformanceTableViewCell = dequeueCell(at: indexPath)
        configurator.configure(cell: cell, model: .init(entity, performers))
        return cell
    }
}

extension PerformancesTableView: FetchedResultsControllerDelegate {

    func updateCell(at indexPath: IndexPath, for entity: Performance) {
        _ = dequeue(at: indexPath, for: entity)
    }
}
