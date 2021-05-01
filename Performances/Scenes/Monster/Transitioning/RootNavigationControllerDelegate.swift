import UIKit

final class RootNavigationControllerDelegate: NSObject {
    private let rootAnimator = RootViewControllerTransitionAnimator()
    private let welcomeAnimator = WelcomeViewControllerTransitionAnimator()
}

extension RootNavigationControllerDelegate: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is RootViewController {
            return rootAnimator
        } else if fromVC is WelcomeViewController && toVC is PromotionViewController {
            return welcomeAnimator
        }
        return nil
    }
}
