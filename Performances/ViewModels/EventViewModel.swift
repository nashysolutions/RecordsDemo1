import UIKit

struct EventViewModel {
    
    let title: String
    let subtitle: String
    let accessoryType: UITableViewCell.AccessoryType
    
    init(title: String, subtitle: String, accessoryType: UITableViewCell.AccessoryType) {
        self.title = title
        self.subtitle = subtitle
        self.accessoryType = accessoryType
    }
    
    init(_ event: Event) {
        let title = EventViewModel.title(for: event)
        let subtitle = EventViewModel.subtitle(for: event)
        let accessoryType = EventViewModel.accessoryType(for: event)
        self.init(title: title, subtitle: subtitle, accessoryType: accessoryType)
    }
    
    static func title(for event: Event) -> String {
        return "Start Date: " + eventDateFormatter.string(from: event.startDate)
    }
    
    static func subtitle(for event: Event) -> String {
        let count = event.performances?.count ?? 0
        let value = (count == 1) ? "performance" : "performances"
        return "\(count) " + value + " registered"
    }
    
    static func accessoryType(for event: Event) -> UITableViewCell.AccessoryType {
        let count = event.performances?.count ?? 0
        return (count == 0) ? .none : .disclosureIndicator
    }
}
