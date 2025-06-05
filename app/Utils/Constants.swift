import UIKit

struct Constants {
    struct Colors {
        // 主要颜色
        static let primaryColor = UIColor.systemBlue
        static let primaryLightColor = UIColor(hex: "#5dade2")
        static let primaryDarkColor = UIColor(hex: "#2874a6")
        
        // 辅助颜色
        static let secondaryColor = UIColor.systemGreen
        static let secondaryLightColor = UIColor(hex: "#f1948a")
        static let secondaryDarkColor = UIColor(hex: "#b03a2e")
        
        // 中性颜色
        static let backgroundColor = UIColor.systemBackground
        static let cardBackgroundColor = UIColor.secondarySystemBackground
        static let separatorColor = UIColor(hex: "#e0e0e0")
        static let lightBackgroundColor = UIColor.systemGray6
        
        // 文本颜色
        static let primaryTextColor = UIColor.label
        static let secondaryTextColor = UIColor.secondaryLabel
        static let hintTextColor = UIColor(hex: "#999999")
        
        // 功能颜色
        static let successColor = UIColor.systemGreen
        static let warningColor = UIColor.systemOrange
        static let errorColor = UIColor.systemRed
        static let infoColor = UIColor.systemBlue
        
        // 强调颜色
        static let accentColor = UIColor.systemOrange
    }
    
    struct FontSize {
        static let caption: CGFloat = 11
        static let caption2: CGFloat = 12
        static let secondary: CGFloat = 14
        static let body: CGFloat = 16
        static let callout: CGFloat = 17
        static let headline: CGFloat = 18
        static let title3: CGFloat = 20
        static let title2: CGFloat = 22
        static let title1: CGFloat = 24
        static let largeTitle: CGFloat = 28
        static let extraLargeTitle: CGFloat = 34
    }
    
    struct Spacing {
        static let extraSmall: CGFloat = 4.0
        static let small: CGFloat = 8.0
        static let medium: CGFloat = 16.0
        static let large: CGFloat = 24.0
        static let extraLarge: CGFloat = 32.0
        static let extraExtraLarge: CGFloat = 48.0
    }
    
    struct CornerRadius {
        static let small: CGFloat = 4.0
        static let medium: CGFloat = 8.0
        static let large: CGFloat = 12.0
        static let extraLarge: CGFloat = 16.0
    }
    
    struct AnimationDuration {
        static let short: TimeInterval = 0.2
        static let medium: TimeInterval = 0.3
        static let long: TimeInterval = 0.5
    }
}

// 扩展UIColor，支持十六进制色值
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
} 