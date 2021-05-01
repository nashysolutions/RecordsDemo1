import UIKit

final class PromotionViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard messageLabel != nil else { return }
        let interval: TimeInterval = 0.6
        UIView.animate(withDuration: interval, animations: {
            self.messageLabel.isHidden = false
        }) { (_) in
            dispatchAfter(seconds: 1, block: {
                self.swapRoot("Main")
            })
        }
        UIView.animate(withDuration: interval / 2.0, delay: interval / 2.0, options: [], animations: {
            self.messageLabel.alpha = 1
        }, completion: nil)
    }
    
    private func swapRoot(_ storyboardName: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard
            let tabController = storyboard.instantiateInitialViewController() as? TabBarController,
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window else {
                preconditionFailure()
        }
        
        tabController.disablePerformersTableViewControllerAnimations()
        
        window.rootViewController = tabController
        
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: {}, completion: { _ in
            tabController.enablePerformersTableViewControllerAnimations()
        })
    }
}
