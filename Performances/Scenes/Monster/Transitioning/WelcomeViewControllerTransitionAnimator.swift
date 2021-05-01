import UIKit

final class WelcomeViewControllerTransitionAnimator: NSObject {
    private var animatorHelper: AnimatorHelper!
}

extension WelcomeViewControllerTransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        let containerView = transitionContext.containerView
        
        guard let toViewController = (transitionContext.viewController(forKey: .to) as? PromotionViewController) else {
            preconditionFailure()
        }
        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        containerView.addSubview(toViewController.view)
        toViewController.view.layoutIfNeeded()
        toViewController.stackView.alpha = 0
        toViewController.view.alpha = 0
        
        let package1 = monster(containerView, transitionContext)
        let fromPosition = package1.fromPosition
        let toPosition = package1.toPosition
        let monsterSnapshot = package1.snapshot
        
        animatorHelper = AnimatorHelper(fromPosition: fromPosition, toPosition: toPosition, duration: animationDuration / 3.0, view: monsterSnapshot)
        animatorHelper.go { (finished) in
            UIView.animate(withDuration: animationDuration / 3.0, animations: {
                toViewController.view.alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: animationDuration / 3.0, animations: {
                    toViewController.stackView.alpha = 1
                }, completion: { _ in
                    guard let fromViewController = (transitionContext.viewController(forKey: .from) as? WelcomeViewController) else {
                        preconditionFailure()
                    }
                    fromViewController.stackView.isHidden = false
                    monsterSnapshot.removeFromSuperview()
                    transitionContext.completeTransition(finished)
                })
            })
            
        }
        
    }
    
    private struct Package1 {
        let snapshot: UIView
        let fromPosition: CGPoint
        let toPosition: CGPoint
    }
    
    private func monster(_ containerView: UIView, _ transitionContext: UIViewControllerContextTransitioning) -> Package1 {
        guard let fromViewController = (transitionContext.viewController(forKey: .from) as? WelcomeViewController) else {
            preconditionFailure()
        }
        guard let snapshot = fromViewController.stackView.snapshotView(afterScreenUpdates: false) else {
            preconditionFailure()
        }
        snapshot.frame = fromViewController.stackView.frame
        containerView.addSubview(snapshot)
        fromViewController.stackView.isHidden = true
        let fromPosition = snapshot.center
        let toY = snapshot.center.y
        let toX = snapshot.center.x - fromViewController.view.bounds.width
        let toPosition = CGPoint(x: toX, y: toY)
        return Package1(snapshot: snapshot, fromPosition: fromPosition, toPosition: toPosition)
    }
}

// would be easier to use a UIViewPropertyAnimator instead of this
private final class AnimatorHelper: NSObject {
    
    typealias Completion = (Bool) -> Void
    
    private let animationName = "name"
    private let animationKey = "key"
    private var completion: Completion?
    
    private let fromPosition: CGPoint
    private let toPosition: CGPoint
    private let duration: TimeInterval
    private let view: UIView
    
    init(fromPosition: CGPoint, toPosition: CGPoint, duration: TimeInterval, view: UIView) {
        self.fromPosition = fromPosition
        self.toPosition = toPosition
        self.duration = duration
        self.view = view
        super.init()
    }
    
    func go(with completion: @escaping Completion) {
        self.completion = completion
        setFinalValues()
        let animation = buildAnimation()
        view.layer.add(animation, forKey: animationKey)
    }
    
    /// http://cubic-bezier.com/#.86,0,.07,1
    /// http://easings.net/#easeInOutQuint
    private func buildAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.values = [NSValue(cgPoint: fromPosition), NSValue(cgPoint: toPosition)]
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.86, 0, 0.07, 1)
        animation.delegate = self
        animation.setValue(animationName, forKey: animationKey)
        return animation
    }
    
    private func setFinalValues() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        view.layer.position = toPosition
        CATransaction.commit()
    }
}

extension AnimatorHelper: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let value = anim.value(forKey: animationKey) as? String
        if (value == animationName) {
            completion?(flag)
        }
    }
}
