import UIKit
import Dequeue

final class PerformerCollectionViewCell: UICollectionViewCell, DequeueableComponentIdentifiable {
    @IBOutlet weak var performerTitleLabel: UILabel!
    @IBOutlet weak var profileBodyLabel: UILabel!
}
