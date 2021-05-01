import UIKit

struct PerformanceViewModel {
    
    let title: NSAttributedString
    let subtitle: NSAttributedString
    
    init(title: NSAttributedString, subtitle: NSAttributedString) {
        self.title = title
        self.subtitle = subtitle
    }
    
    init(_ performance: Performance, _ performers: Set<Performer>? = nil) {
        let title = PerformanceViewModel.title(for: performance)
        let subtitle = PerformanceViewModel.subtitle(for: performance, highlightingPerformers: performers)
        self.init(title: title, subtitle: subtitle)
    }
    
    static func title(for performance: Performance) -> NSAttributedString {
        let value = performance.group_.rawValue + " " + performance.ability_.rawValue
        return NSAttributedString(string: value, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    static func subtitle(for performance: Performance, highlightingPerformers performers: Set<Performer>? = nil) -> NSAttributedString {
        return performance.performers.reduce(NSMutableAttributedString()) { (accumulation, performer) -> NSMutableAttributedString in
            let value: String
            if accumulation.length == 0 {
                value = performer.fullName
            } else {
                value = ", " + performer.fullName
            }
            if let performers = performers, performers.contains(where: { $0.matches(fullName: performer.fullName) }) {
                return accumulation.bold(value)
            }
            return accumulation.normal(value)
        }
    }
}
