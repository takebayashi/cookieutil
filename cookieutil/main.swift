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
        let subargs = join(" ", command.2)
        println("  \(command.0) \(subargs)\t\(command.3)")
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

func performDelete(args: [String]) -> Int32 {
    let domain = args[0]
    let path = args[1]
    let name = args[2]
    let storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    let cookies = (storage.cookies! as! [NSHTTPCookie]).filter { cookie in
        cookie.domain == domain && cookie.path! == path && cookie.name == name
    }
    for cookie in cookies {
        storage.deleteCookie(cookie)
        println(cookie.toLine())
    }
    return 0;
}

enum Argument: Int {
    case Command = 1
}

let commands = [
    ("list", performLs, [], "List all stored cookies"),
    ("delete", performDelete, ["domain", "path", "name"], "List all stored cookies"),
    ("help", performHelp, [], "Show help")
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
