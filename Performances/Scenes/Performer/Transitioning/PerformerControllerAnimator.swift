import UIKit

final class PerformerControllerAnimator: NSObject {
    var animator: UIViewPropertyAnimator!
}

extension PerformerControllerAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = (transitionContext.viewController(forKey: .from) as? PerformersTableViewController) else {
            preconditionFailure()
        }
        guard let toViewController = (transitionContext.viewController(forKey: .to) as? PerformerViewController) else {
            preconditionFailure()
        }
        
        let containerView = transitionContext.containerView
        
        /* Prepare
         ===============
         * fromViewController.view is subview of containerView by default
         * the toViewController.view is our responsibility to manage here
         * prevent fromViewController tableView animations during this transition
         */
        fromViewController.tableViewHandler.animationsEnabled = false
        containerView.addSubview(toViewController.view)
        toViewController.view.layoutIfNeeded()
        
        /* Clone
         ===============
         * tableView: visible region cloned and added on top to obscure original.
         * profileImageView: cloned and added on top to obscure original. will be animated so original will be hidden later in this lexical scope.
         */
        let clonedTableView: TableClone = cloneTableView(using: transitionContext) // source: fromViewController
        let clonedBodyLabel: UILabel = cloneBodyLabel(using: transitionContext) // source: toViewController
        let clonedProfileImageView: DummyProfileImageView = cloneSelectedCellProfileImageView(using: transitionContext) // source: fromViewController
        
        containerView.addSubview(clonedTableView)
        containerView.addSubview(clonedBodyLabel)
        containerView.addSubview(clonedProfileImageView)
        
        /* Hide
         ===============
         */
        clonedBodyLabel.alpha = 0
        toViewController.view.isHidden = true
        toggleFromProfileImageViewHiddenState(to: true, using: transitionContext)
        toggleToProfileImageViewHiddenState(to: true, using: transitionContext)
        
        /* Animate
         ===============
         */
        let animationDuration = transitionDuration(using: transitionContext)
        
        animator = UIViewPropertyAnimator(
            duration: animationDuration,
            controlPoint1: CGPoint(x: 0.86, y: 0),
            controlPoint2: CGPoint(x: 0.07, y: 1),
            animations: {
                clonedProfileImageView.frame = self.profileImageViewToFrame(using: transitionContext)
                clonedProfileImageView.layer.cornerRadius = self.profileImageViewToRadius(using: transitionContext)
        })
        
        animator.addAnimations({
            clonedBodyLabel.alpha = 1
        }, delayFactor: 2.5/3.0)
        
        animator.addCompletion { _ in
            /* Remove Clones and Unhide Originals
             ===============
             */
            clonedProfileImageView.removeFromSuperview()
            clonedTableView.removeFromSuperview()
            clonedBodyLabel.removeFromSuperview()
            fromViewController.tableViewHandler.animationsEnabled = true
            toViewController.view.isHidden = false
            self.toggleToProfileImageViewHiddenState(to: false, using: transitionContext)
            self.toggleFromProfileImageViewHiddenState(to: false, using: transitionContext)
            transitionContext.completeTransition(true)
        }
        
        animator.startAnimation()
        
        clonedTableView.animate(animationDuration)
    }
    
    private func toggleFromProfileImageViewHiddenState(to isHidden: Bool, using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = (transitionContext.viewController(forKey: .from) as? PerformersTableViewController) else {
            preconditionFailure()
        }
        guard let selectedIndexPath = fromViewController.tableViewHandler.indexPathForSelectedRow else {
            preconditionFailure()
        }
        guard let cell = (fromViewController.tableView.cellForRow(at: selectedIndexPath) as? PerformerTableViewCell) else {
            preconditionFailure()
        }
        guard let fromProfileImageView = cell.performerImageView else {
            preconditionFailure()
        }
        fromProfileImageView.isHidden = isHidden
    }
    
    private func toggleToProfileImageViewHiddenState(to isHidden: Bool, using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = (transitionContext.viewController(forKey: .to) as? PerformerViewController) else {
            preconditionFailure()
        }
        guard let profileImageView = toViewController.profileImageView else {
            preconditionFailure()
        }
        profileImageView.isHidden = isHidden
    }
    
    private func cloneBodyLabel(using transitionContext: UIViewControllerContextTransitioning) -> UILabel {
        guard let toViewController = (transitionContext.viewController(forKey: .to) as? PerformerViewController) else {
            preconditionFailure()
        }
        let containerView = transitionContext.containerView
        var frame = containerView.convert(toViewController.bodyLabel.frame, from: toViewController.bodyLabel.superview)
        frame.origin.y -= additionalHeight(using: transitionContext)
        let label = UILabel(frame: frame)
        label.text = toViewController.bodyLabel.text
        label.textColor = toViewController.bodyLabel.textColor
        label.textAlignment = toViewController.bodyLabel.textAlignment
        label.font = toViewController.bodyLabel.font
        label.numberOfLines = toViewController.bodyLabel.numberOfLines
        return label
    }
    
    private func profileImageViewToFrame(using transitionContext: UIViewControllerContextTransitioning) -> CGRect {
        guard let toViewController = (transitionContext.viewController(forKey: .to) as? PerformerViewController) else {
            preconditionFailure()
        }
        let containerView = transitionContext.containerView
        guard let profileImageView = toViewController.profileImageView else {
            preconditionFailure()
        }
        var frame = containerView.convert(profileImageView.frame, from: profileImageView.superview)
        frame.origin.y -= additionalHeight(using: transitionContext)
        return frame
    }
    
    /// The UISearchController cocks everything up
    func additionalHeight(using transitionContext: UIViewControllerContextTransitioning) -> CGFloat {
        guard let fromViewController = (transitionContext.viewController(forKey: .from) as? PerformersTableViewController) else {
            preconditionFailure()
        }
        guard let searchController = fromViewController.navigationItem.searchController else {
            preconditionFailure()
        }
        return searchController.searchBar.bounds.height
    }
    
    private func profileImageViewToRadius(using transitionContext: UIViewControllerContextTransitioning) -> CGFloat {
        guard let toViewController = (transitionContext.viewController(forKey: .to) as? PerformerViewController) else {
            preconditionFailure()
        }
        guard let profileImageView = toViewController.profileImageView else {
            preconditionFailure()
        }
        return profileImageView.bounds.width / 2.0
    }
    
    private func cloneTableView(using transitionContext: UIViewControllerContextTransitioning) -> TableClone {
        guard let fromViewController = (transitionContext.viewController(forKey: .from) as? PerformersTableViewController) else {
            preconditionFailure()
        }
        guard let selectedIndexPath = fromViewController.tableViewHandler.indexPathForSelectedRow else {
            preconditionFailure()
        }
        return TableClone.create(for: fromViewController.tableView, selectedIndexPath, additionalHeight: additionalHeight(using: transitionContext))
    }
    
    private func cloneSelectedCellProfileImageView(using transitionContext: UIViewControllerContextTransitioning) -> DummyProfileImageView {
        guard let fromViewController = (transitionContext.viewController(forKey: .from) as? PerformersTableViewController) else {
            preconditionFailure()
        }
        guard let selectedIndexPath = fromViewController.tableViewHandler.indexPathForSelectedRow else {
            preconditionFailure()
        }
        guard let cell = (fromViewController.tableView.cellForRow(at: selectedIndexPath) as? PerformerTableViewCell) else {
            preconditionFailure()
        }
        let containerView = transitionContext.containerView
        guard let original = cell.performerImageView else {
            preconditionFailure()
        }
        let frame = containerView.convert(original.frame, from: original.superview)
        return DummyProfileImageView(frame: frame, original)
    }
}
 
