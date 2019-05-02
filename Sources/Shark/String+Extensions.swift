import Foundation

extension String {
    private static let forbiddenKeywords = ["associatedtype", "class", "deinit", "enum", "extension", "fileprivate", "func", "import", "init", "inout", "internal", "let",
                                            "open", "operator", "private", "protocol", "public", "static", "struct", "subscript", "typealias", "var", "break", "case", "continue",
                                            "default", "defer", "do", "else", "fallthrough", "for", "guard", "if", "in", "repeat", "return", "switch", "where", "while", "Any",
                                            "catch", "false", "is", "nil", "rethrows", "super", "self", "Self", "throw", "throws", "true", "try", "#available", "#colorLiteral",
                                            "#column", "#else", "#elseif", "#endif", "#error", "#file", "#fileLiteral", "#function", "#if", "#imageLiteral",  "#line", "#selector",
                                            "#sourceLocation", "#warning", "associativity", "convenience", "dynamic", "didSet", "final", "get", "infix", "indirect", "lazy", "left",
                                            "mutating", "none", "nonmutating", "optional", "override", "postfix", "precedence", "prefix", "Protocol", "required", "right",
                                            "set", "Type", "unowned", "weak", "willSet", "__COLUMN__", "__FILE__", "__FUNCTION__", "__LINE__"]
    
    init(indentLevel: Int) {
        self.init(repeating: " ", count: indentLevel * 4)
    }
    
    var expandingTildeInPath: String {
        return (self as NSString).expandingTildeInPath
    }
    
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    func appendingPathComponent(_ pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
    
    var filenameSanitized: String {
        return self
            .deletingPathExtension
            .components(separatedBy: .init(charactersIn: "/\\?%*|\"<>"))
            .joined()
    }
    
    var casenameSanitized: String {
        guard isEmpty == false else { return self }
        
        var result = self
        let startIndex = result.startIndex
        
        //First try replacing -'s with _'s only, then remove illegal characters
        if result.contains("-") {
            result = replacingOccurrences(of: "-", with: "_")
        }
        
        while result[startIndex...startIndex].rangeOfCharacter(from: .firstLetterForbidden) != nil || String.forbiddenKeywords.contains(result) {
            result = result.underscored
        }

        if result[result.index(after: startIndex)...].rangeOfCharacter(from: .forbidden) != nil {
            result = result.components(separatedBy: .forbidden).joined(separator: "")
        }
        
        return result
    }
    
    var underscored: String {
        return "_" + self
    }
    
    func indented(withLevel level: Int) -> String {
        return mapLines { String(indentLevel: level) + $0 }
    }
    
    func mapLines(_ transform: (String) -> String) -> String {
        return components(separatedBy: .newlines).map(transform).joined(separator: "\n")
    }
}