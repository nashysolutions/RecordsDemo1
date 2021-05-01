import UIKit
import Dequeue
import Records

final class PerformersCollectionView: UICollectionView, DequeueableCollectionView {
    
    func dequeue(at indexPath: IndexPath, for entity: Performer) -> PerformerCollectionViewCell {
        let configurator = PerformerCollectionViewCellConfigurator<PerformerViewModel>(
            titleKeyPath: \.title,
            subtitleKeyPath: \.subtitle
        )
        let cell: PerformerCollectionViewCell = dequeueCell(at: indexPath)
        configurator.configure(cell: cell, model: .init(entity))
        return cell
    }
}

extension PerformersCollectionView: FetchedResultsControllerDelegate {
    
    func updateCell(at indexPath: IndexPath, for entity: Performer) {
        _ = dequeue(at: indexPath, for: entity)
    }
}
