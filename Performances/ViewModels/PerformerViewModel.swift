import Foundation

struct PerformerViewModel {
    
    let title: String
    let subtitle: String
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
    
    init(_ performer: Performer) {
        let title = PerformerViewModel.title(for: performer)
        let subtitle = PerformerViewModel.subtitle(for: performer)
        self.init(title: title, subtitle: subtitle)
    }
    
    static func title(for performer: Performer) -> String {
        return performer.fullName
    }
    
    static func subtitle(for performer: Performer) -> String {
        let party = performer.party.name
        guard let value = performer.age else {
            preconditionFailure()
        }
        let age = value
        let word = (age == 1) ? "year" : "years"
        let gender = performer.gender_.rawValue.capitalized
        return """
        • \(age) \(word) old
        • \(gender)
        • Member of \(party)
        """
    }
}
