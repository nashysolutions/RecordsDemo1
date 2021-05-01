import UIKit
import Dequeue

class PerformerTableViewCell: UITableViewCell, DequeueableComponentIdentifiable {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var performerContentView: UIView! {
        didSet {
            performerContentView.backgroundColor = blue
        }
    }
    
    @IBOutlet weak var performerImageView: PerformerImageView! {
        didSet {
            performerImageView.backgroundColor = lightGray
        }
    }
    
    @IBOutlet weak var performerTitleLabel: UILabel! {
        didSet {
            performerTitleLabel.numberOfLines = 1
            performerTitleLabel.textColor = black
            performerTitleLabel.font = font1
        }
    }
    
    @IBOutlet weak var profileBodyLabel: UILabel! {
        didSet {
            profileBodyLabel.lineBreakMode = .byWordWrapping
            profileBodyLabel.numberOfLines = 3
            profileBodyLabel.textColor = black
            profileBodyLabel.font = font2
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = lightGray
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        updateViews(highlighted, animated: animated)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateViews(selected, animated: animated)
    }
    
    private func updateViews(_ engaged: Bool, animated: Bool) {
        if animated == false {
            updateViews(engaged)
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
                self.updateViews(engaged)
            }, completion: nil)
        }
    }
    
    private func updateViews(_ engaged: Bool) {
        performerContentView.backgroundColor = engaged ? red : blue
        performerImageView.backgroundColor = engaged ? black : lightGray
    }
    
    func animate() {
        animateProfileContentView()
        animateProfileImageView()
    }
    
    private func animateProfileContentView() {
        guard let value = performerContentView else {
            preconditionFailure()
        }
        let view = value
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, -240, 0, 0)
        view.alpha = 0
        view.layer.transform = transform
        UIView.animate(
            withDuration: 1.5,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.2,
            options: [.allowUserInteraction, .curveEaseInOut],
            animations: {
                view.layer.transform = CATransform3DIdentity
                view.alpha = 1
        })
    }
    
    private func animateProfileImageView() {
        guard let value = performerImageView else {
            preconditionFailure()
        }
        let view = value
        var transform = CATransform3DIdentity
        transform = CATransform3DScale(transform, 0.6, 0.6, 0)
        view.layer.transform = transform
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseOut],
            animations: {
                view.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
    
    func snapshotSomeUINotAll() -> PerformerTableViewCellClone {
        let cell = PerformerTableViewCellClone(frame: frame)
        cell.backgroundColor = backgroundColor
        let profileContentView = copyProfileContentView()
        profileContentView.addSubview(copyStackView())
        cell.addSubview(profileContentView)
        cell.contentView = profileContentView
        return cell
    }
    
    private func copyProfileContentView() -> UIView {
        let view = UIView(frame: performerContentView.frame)
        view.backgroundColor = performerContentView.backgroundColor
        return view
    }
    
    private func copyStackView() -> UIView {
        guard let value = stackView.snapshotView(afterScreenUpdates: false) else {
            preconditionFailure()
        }
        let view = value
        view.frame = stackView.frame
        return view
    }
}

final class PerformerImageView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = bounds.width / 2.0
        layer.cornerRadius = radius
    }
}
