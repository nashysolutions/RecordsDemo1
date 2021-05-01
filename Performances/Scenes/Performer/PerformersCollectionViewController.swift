import UIKit

final class PerformersCollectionViewController: UIViewController {
    
    let performersController = PerformerController<PerformersCollectionView>()
    
    private lazy var collectionViewHandler = PerformerCollectionViewHandler(performersController)
    
    @IBOutlet weak var collectionView: PerformersCollectionView! {
        didSet {
            collectionView.dataSource = collectionViewHandler
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performersController.delegate = collectionView
    }
}
