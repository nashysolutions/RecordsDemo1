import Foundation

let message1 = "At this point in the demo we expect the core data stack to be available and stable. Otherwise what's the point right? I mean, how did this even happen right? What, the database is full? Nah. It's probably because I made a stupid mistake. I'm so glad I got a fatalError in here, so I have a clear idea of what's going on."

func message2(_ placer: Any) -> String {
    return "We were expecting \(typeName(placer))? Wtf? Totally unexpected."
}

func message3(_ placer: String) -> String {
    return "We were expecting \(placer)? Wtf? Totally unexpected."
}

private func typeName(_ some: Any) -> String {
    return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
}

let message4 = "We assumed the user wouldn't delete all of the data."
