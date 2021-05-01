import UIKit

let blue = #colorLiteral(red: 0.6666666667, green: 0.7176470588, blue: 0.8666666667, alpha: 1)
let red = #colorLiteral(red: 0.9215686275, green: 0.4274509804, blue: 0.262745098, alpha: 1)
let lightGray = #colorLiteral(red: 0.8588235294, green: 0.8941176471, blue: 0.8941176471, alpha: 1)
let midGray = #colorLiteral(red: 0.7333333333, green: 0.7568627451, blue: 0.7647058824, alpha: 1)
let darkGray = #colorLiteral(red: 0.1568627451, green: 0.1764705882, blue: 0.1843137255, alpha: 1)
let orange = #colorLiteral(red: 0.9098039216, green: 0.6470588235, blue: 0.1882352941, alpha: 1)
let green = #colorLiteral(red: 0.3098039216, green: 0.6784313725, blue: 0.6549019608, alpha: 1)
let white = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

let font1 = UIFont.boldSystemFont(ofSize: 21)
let font2 = UIFont.systemFont(ofSize: 18)
let font3 = UIFont.boldSystemFont(ofSize: 36)

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        guard let font = UIFont(name: "AvenirNext-DemiBold", size: 14) else {
            preconditionFailure("The fonts have been ripped out of the project. Hmm...")
        }
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        guard let font = UIFont(name: "AvenirNext-Regular", size: 14) else {
            preconditionFailure("The fonts have been ripped out of the project. Hmm...")
        }
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        append(NSAttributedString(string: text, attributes: attrs))
        return self
    }
}
