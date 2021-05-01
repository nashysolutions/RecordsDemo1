import UIKit

final class RootViewController: UIViewController {
    
    @IBOutlet weak var monsterImageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dispatchAfter(seconds: 0.5) {
            self.performSegue(withIdentifier: "Show", sender: nil)
        }
    }
}
