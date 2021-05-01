import UIKit

final class DummyProfileImageView: UIView {
    
    init(frame: CGRect, _ profileImageView: UIView) {
        super.init(frame: frame)
        layer.masksToBounds = profileImageView.layer.masksToBounds
        layer.cornerRadius = profileImageView.layer.cornerRadius
        guard let value = profileImageView.backgroundColor else {
            preconditionFailure()
        }
        backgroundColor = value
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
