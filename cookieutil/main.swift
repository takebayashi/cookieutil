import Foundation

extension NSHTTPCookie {
    
    func toLine() -> String {
        let delimiter = "\t"
        let fields = [domain, path!, name, value!]
        return delimiter.join(fields)
    }
    
}

func performHelp(args: [String]) -> Int32 {
    println("Usage:  cookieutil <command>")
    println()
    println("Commands:")
    for command in commands {
        println("  \(command.0)\t\(command.2)")
    }
    return 1
}

func performLs(args: [String]) -> Int32 {
    let storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    for cookie in (storage.cookies! as! [NSHTTPCookie]) {
        println(cookie.toLine())
    }
    return 0;
}

enum Argument: Int {
    case Command = 1
}

let commands = [
    ("list", performLs, "List all stored cookies"),
    ("help", performHelp, "Show help")
]

func detectCommand() -> String {
    if Process.argc - 1 < Argument.Command.rawValue {
        return "help"
    }
    else {
        return String.fromCString(Process.arguments[Argument.Command.rawValue])!
    }
}

let commandName = detectCommand()
let command = commands.filter({command in command.0 == commandName}).first!.1
let commandArgs = Process.arguments[(Argument.Command.rawValue + 1)..<Process.arguments.count]
command(Array(commandArgs))
