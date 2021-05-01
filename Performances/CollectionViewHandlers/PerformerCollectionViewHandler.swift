import UIKit

final class PerformerCollectionViewHandler: NSObject {
    
    private let performerController: PerformerController<PerformersCollectionView>
    
    init(_ performerController: PerformerController<PerformersCollectionView>) {
        self.performerController = performerController
    }
}

extension PerformerCollectionViewHandler: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return performerController.fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return performerController.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionView = collectionView as? PerformersCollectionView else {
            fatalError("Must have PerformerCollectionView here.")
        }
        let entity = performerController.fetchedResultsController.object(at: indexPath)
        return collectionView.dequeue(at: indexPath, for: entity)
    }
}
