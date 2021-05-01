import UIKit

struct PerformanceTableViewCellConfigurator<Model> {
    
    let titleKeyPath: KeyPath<Model, NSAttributedString>
    let subtitleKeyPath: KeyPath<Model, NSAttributedString>
    
    func configure(cell: PerformanceTableViewCell, model: Model) {
        cell.textLabel?.attributedText = model[keyPath: titleKeyPath]
        cell.detailTextLabel?.attributedText = model[keyPath: subtitleKeyPath]
    }
}
