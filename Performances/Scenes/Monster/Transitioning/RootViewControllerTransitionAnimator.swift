import UIKit

final class RootViewControllerTransitionAnimator: NSObject {}

extension RootViewControllerTransitionAnimator: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.6
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let animationDuration = transitionDuration(using: transitionContext)
    
    let containerView = transitionContext.containerView
    
    guard let toViewController = (transitionContext.viewController(forKey: .to) as? WelcomeViewController) else {
        preconditionFailure()
    }
    toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
    toViewController.view.layoutIfNeeded()
    let finalFrame = containerView.convert(toViewController.monsterImageView.frame, from: toViewController.monsterImageView.superview)
    toViewController.monsterImageView.isHidden = true
    containerView.addSubview(toViewController.view)
    toViewController.view.alpha = 0
    
    guard let fromViewController = (transitionContext.viewController(forKey: .from) as? RootViewController) else {
        preconditionFailure()
    }
    let snapshot = UIImageView(image: fromViewController.monsterImageView.image)
    snapshot.contentMode = .scaleAspectFit
    snapshot.frame = containerView.convert(fromViewController.monsterImageView.frame, from: fromViewController.monsterImageView.superview)
    containerView.addSubview(snapshot)
    fromViewController.monsterImageView.isHidden = true
    
    UIView.animate(withDuration: animationDuration / 2.0, delay: 0, options: [.curveEaseInOut], animations: {
      snapshot.frame = finalFrame
    }) { (_) in
      toViewController.monsterImageView.isHidden = false
      UIView.animate(withDuration: animationDuration / 2.0, animations: {
        toViewController.view.alpha = 1
      }, completion: { (finished) in
        snapshot.removeFromSuperview()
        fromViewController.monsterImageView.isHidden = false
        transitionContext.completeTransition(finished)
      })
    }
  }
}
