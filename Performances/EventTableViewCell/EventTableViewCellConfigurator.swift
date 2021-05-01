import UIKit

struct EventTableViewCellConfigurator<Model> {
    
    let titleKeyPath: KeyPath<Model, String>
    let subtitleKeyPath: KeyPath<Model, String>
    let accessoryTypeKeyPath: KeyPath<Model, UITableViewCell.AccessoryType>
    
    func configure(cell: EventTableViewCell, model: Model) {
        cell.textLabel?.text = model[keyPath: titleKeyPath]
        cell.detailTextLabel?.text = model[keyPath: subtitleKeyPath]
        cell.accessoryType = model[keyPath: accessoryTypeKeyPath]
    }
}
