import UIKit

final class PerformersNavigationStackHandler: NSObject {
  fileprivate let animator = PerformerControllerAnimator()
}

extension PerformersNavigationStackHandler: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if toVC is PerformerViewController {
      return animator
    }
    return nil
  }
}
