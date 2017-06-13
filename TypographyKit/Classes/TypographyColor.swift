//
//  TypographyColor.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/20/17.
//
//

import Foundation

enum TypographyColor {
    case black
    case darkGray
    case lightGray
    case white
    case gray
    case red
    case green
    case blue
    case cyan
    case yellow
    case magenta
    case orange
    case purple
    case brown
    case clear
    case hex(string: String)
    case named(string: String)
    case rgb(r: Float, g: Float, b: Float)
    case rgba(r: Float, g: Float, b: Float, a: Float)
    
    static var colorNameMap: [String: UIColor] {
        return ["black": .black,
                "darkGray": .darkGray,
                "lightGray": .lightGray,
                "white": .white,
                "gray": .gray,
                "red": .red,
                "green": .green,
                "blue": .blue,
                "cyan": .cyan,
                "yellow": .yellow,
                "magenta": .magenta,
                "orange": .orange,
                "purple": .purple,
                "brown": .brown,
                "clear": .clear]
    }
    
    var cgColor: CGColor {
        return self.uiColor.cgColor
    }
    
    var ciColor: CIColor {
        return self.uiColor.ciColor
    }
    
    var uiColor: UIColor {
        switch self {
        case .black:
            return .black
        case .darkGray:
            return .darkGray
        case .lightGray:
            return .lightGray
        case .white:
            return .white
        case .gray:
            return .gray
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        case .cyan:
            return .cyan
        case .yellow:
            return .yellow
        case .magenta:
            return .magenta
        case .orange:
            return .orange
        case .purple:
            return .purple
        case .brown:
            return .brown
        case .clear:
            return .clear
        case .named(let colorName):
            return TypographyColor.colorNameMap[colorName]! // Previously validated
        case .hex(let hexString):
            return TypographyColor.parseHex(hexString: hexString)!.uiColor // Previously validated
        case .rgb(let r, let g, let b):
            return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
        case .rgba(let r, let g, let b, let a):
            return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
        }
    }
    
    init?(string: String) {
        switch string {
        case "#[a-zA-Z0-9]{6}":
            if let _ = TypographyColor.parseHex(hexString: string) { // Check can be converted to a color
                self = .hex(string: string)
                break
            }
            return nil
        case "rgb\\(([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\)":
            let colorComponentPattern = "[01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]"
            let colorComponentRegEx = try! NSRegularExpression(pattern: colorComponentPattern,
                                                               options: .dotMatchesLineSeparators)
            let matches = colorComponentRegEx.matches(in: string, options: [], range: NSMakeRange(0, string.characters.count))
            var colorValues: [String] = []
            for match in matches {
                let matchEndIndex = match.range.location + match.range.length
                let startIdx = string.index(string.startIndex, offsetBy: match.range.location)
                let endIdx = string.index(string.startIndex, offsetBy: matchEndIndex)
                let range = startIdx..<endIdx
                colorValues.append(string[range])
            }
            if colorValues.count == 3,
                let red = Float(colorValues[0]),
                let green = Float(colorValues[1]),
                let blue = Float(colorValues[2]) {
                self = .rgb(r: red / 255.0, g: green / 255.0, b: blue / 255.0)
                break
            }
            return nil
        default:
            if let _ = TypographyColor.colorNameMap[string] {
                self = .named(string: string)
                break
            }
            return nil
        }
    }
    
    /// Parses a hexadecimal string to a color (if possible)
    private static func parseHex(hexString: String) -> TypographyColor? {
        let r = hexString[hexString.index(after: hexString.startIndex)..<hexString.index(hexString.index(after: hexString.startIndex), offsetBy: 2)]
        let g = hexString[hexString.index(hexString.startIndex, offsetBy: 3)..<hexString.index(hexString.startIndex, offsetBy: 5)]
        let b = hexString[hexString.index(hexString.startIndex, offsetBy: 5)..<hexString.endIndex]
        
        if let rInt = UInt(r, radix: 16),
            let gInt = UInt(g, radix: 16),
            let bInt = UInt(b, radix: 16) {
            let red = Float(rInt) / 255.0
            let green = Float(gInt) / 255.0
            let blue = Float(bInt) / 255.0
            return .rgb(r: red,
                        g: green,
                        b: blue)
        }
        return nil
    }
}
