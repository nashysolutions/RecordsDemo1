import UIKit

func dispatchAfter(seconds: Double, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: block)
}

let eventDateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  formatter.timeStyle = .none
  return formatter
}()

func contentsOf(resource r: String, extension e: String) throws -> Data {
    let bundle = Bundle(for: Event.self)
    let url = bundle.url(forResource: r, withExtension: e)!
    return try String(contentsOf: url).data(using: .utf8)!
}
