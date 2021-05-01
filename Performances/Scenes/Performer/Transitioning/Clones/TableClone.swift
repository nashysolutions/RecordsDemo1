import UIKit

final class TableClone: UIView {
  
  /// Creates a clone of the visible portion of the ProfileTableView
  /// The additional height is to accomodate the UISearchController
  static func create(for tableView: PerformerTableView, _ selectedIndexPath: IndexPath, additionalHeight: CGFloat) -> TableClone {
    var frame = tableView.frame
    frame.origin.y += additionalHeight + tableView.contentInset.top
    let containerView = TableClone(frame: frame)
    containerView.backgroundColor = tableView.backgroundColor
    guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else {
        preconditionFailure()
    }
    for indexPath in visibleIndexPaths {
        guard let cell = (tableView.cellForRow(at: indexPath) as? PerformerTableViewCell) else {
            preconditionFailure()
        }
      let snapshot: UIView
      if indexPath == selectedIndexPath {
        snapshot = cell.snapshotSomeUINotAll()
      } else {
        guard let value = cell.snapshotView(afterScreenUpdates: false) else {
            preconditionFailure()
        }
        snapshot = value
      }
      snapshot.frame = containerView.convert(cell.frame, from: cell.superview)
      containerView.addSubview(snapshot)
    }
    return containerView
  }
  
  /// Only one gravity behaviour per animator allowed
  private var animators: [UIDynamicAnimator] = []
  
  func animate(_ animationDuration: TimeInterval) {
    var upItems = [UIView]() // some cells slide up
    var downItems = [UIView]() // some cells slide down
    var animateUp: Bool = true
    for subview in subviews {
      let selectedCell = subview is PerformerTableViewCellClone
      if selectedCell {
        animateUp = false
        // fade and scale this one out
        guard let value = (subview as? PerformerTableViewCellClone) else {
            preconditionFailure()
        }
        value.animate(with: animationDuration)
        continue // skip loop because this one won't go up or down
      }
      if animateUp {
        upItems.append(subview)
      } else {
        downItems.append(subview)
      }
    }
    for (index, item) in upItems.enumerated() {
      let animator = UIDynamicAnimator(referenceView: self)
      let gravity = UIGravityBehavior(items: [item])
      let value = (upItems.count - index) * -1
      gravity.gravityDirection = CGVector(dx: 0, dy: value)
      animator.addBehavior(gravity) // gravity kicks in now
      animators.append(animator)
    }
    for (index, item) in downItems.reversed().enumerated() {
      let animator = UIDynamicAnimator(referenceView: self)
      let gravity = UIGravityBehavior(items: [item])
      let value = (downItems.count - index)
      gravity.gravityDirection = CGVector(dx: 0, dy: value)
      animator.addBehavior(gravity) // gravity kicks in now
      animators.append(animator)
    }
  }
}
