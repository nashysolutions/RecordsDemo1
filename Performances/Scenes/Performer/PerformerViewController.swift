import UIKit

final class PerformerViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: PerformerImageView!
    
    var performer: Performer?
    
    @IBOutlet weak var bodyLabel: UILabel! {
        didSet {
            bodyLabel.lineBreakMode = .byWordWrapping
            bodyLabel.numberOfLines = 0
            bodyLabel.textColor = black
            bodyLabel.font = font3
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bodyLabel.text = performer?.fullName
    }
}
