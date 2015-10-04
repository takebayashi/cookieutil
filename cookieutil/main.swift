import Foundation

extension NSHTTPCookie {
    
    func toLine() -> String {
        let delimiter = "\t"
        let fields = [domain, path, name, value]
        return fields.joinWithSeparator(delimiter)
    }
    
}

func performHelp(args: [String]) -> Int32 {
    print("Usage:  cookieutil <command>")
    print("")
    print("Commands:")
    for command in commands {
        let subargs = (command.2).joinWithSeparator(" ")
        print("  \(command.0) \(subargs)")
    }
    return 1
}

func performLs(args: [String]) -> Int32 {
    let storage = NSHTTPCookieStorage.sharedCookieStorageForGroupContainerIdentifier("Cookies")
    for cookie in (storage.cookies! ) {
        print(cookie.toLine())
    }
    return 0;
}

func performDelete(args: [String]) -> Int32 {
    let domain = args[0]
    let path = args[1]
    let name = args[2]
    let storage = NSHTTPCookieStorage.sharedCookieStorageForGroupContainerIdentifier("Cookies")
    let matcher = { (cookie: NSHTTPCookie) in
        cookie.domain == domain && cookie.path == path && cookie.name == name
    }
    let cookies = storage.cookies!.filter(matcher)
    for cookie in cookies {
        storage.deleteCookie(cookie)
        print(cookie.toLine())
    }
    return 0;
}

enum Argument: Int {
    case Command = 1
}

let commands = [
    ("list", performLs, []),
    ("delete", performDelete, ["<domain>", "<path>", "<name>"]),
    ("help", performHelp, [])
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
