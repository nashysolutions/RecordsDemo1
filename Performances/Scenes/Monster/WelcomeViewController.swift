import UIKit

final class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var monsterImageView: UIImageView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        dispatchAfter(seconds: 0.5) {
            self.performSegue(withIdentifier: "Show", sender: nil)
        }
    }
}

