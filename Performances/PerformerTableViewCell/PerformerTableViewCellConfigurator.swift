import UIKit

struct PerformerTableViewCellConfigurator<Model> {
    
    let titleKeyPath: KeyPath<Model, String>
    let subtitleKeyPath: KeyPath<Model, String>
    
    func configure(cell: PerformerTableViewCell, model: Model) {
        cell.performerTitleLabel?.text = model[keyPath: titleKeyPath]
        cell.profileBodyLabel?.text = model[keyPath: subtitleKeyPath]
    }
}
