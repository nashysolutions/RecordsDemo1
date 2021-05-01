import UIKit

final class PerformerTableViewCellClone: UIView {
    
    weak var contentView: UIView?
    
    private var animator: UIViewPropertyAnimator!
    
    func animate(with duration: TimeInterval) {
        
        let interval = duration / 4.0
        
        animator = UIViewPropertyAnimator(
            duration: interval,
            controlPoint1: CGPoint(x: 0.47, y: 0),
            controlPoint2: CGPoint(x: 0.745, y: 0.715),
            animations: {
                guard let value = self.contentView else {
                    preconditionFailure()
                }
                value.backgroundColor = orange
        })

        animator.addAnimations({
            guard let value = self.contentView else {
                preconditionFailure()
            }
                value.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
                value.alpha = 0
        }, delayFactor: 1/8.0)
        
        animator.startAnimation()
        
    }
}
