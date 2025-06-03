import UIKit

struct Constants {
    struct Colors {
        // 主要颜色
        static let primaryColor = UIColor(hex: "#3498db")
        static let primaryLightColor = UIColor(hex: "#5dade2")
        static let primaryDarkColor = UIColor(hex: "#2874a6")
        
        // 辅助颜色
        static let secondaryColor = UIColor(hex: "#e74c3c")
        static let secondaryLightColor = UIColor(hex: "#f1948a")
        static let secondaryDarkColor = UIColor(hex: "#b03a2e")
        
        // 中性颜色
        static let backgroundColor = UIColor(hex: "#f5f5f5")
        static let cardBackgroundColor = UIColor(hex: "#ffffff")
        static let separatorColor = UIColor(hex: "#e0e0e0")
        
        // 文本颜色
        static let primaryTextColor = UIColor(hex: "#333333")
        static let secondaryTextColor = UIColor(hex: "#666666")
        static let hintTextColor = UIColor(hex: "#999999")
        
        // 功能颜色
        static let successColor = UIColor(hex: "#2ecc71")
        static let warningColor = UIColor(hex: "#f1c40f")
        static let errorColor = UIColor(hex: "#e74c3c")
        static let infoColor = UIColor(hex: "#3498db")
    }
    
    struct FontSize {
        static let largeTitle: CGFloat = 24.0
        static let title: CGFloat = 20.0
        static let subtitle: CGFloat = 18.0
        static let body: CGFloat = 16.0
        static let secondary: CGFloat = 14.0
        static let caption: CGFloat = 12.0
    }
    
    struct Spacing {
        static let small: CGFloat = 8.0
        static let medium: CGFloat = 16.0
        static let large: CGFloat = 24.0
        static let extraLarge: CGFloat = 32.0
    }
    
    struct CornerRadius {
        static let small: CGFloat = 4.0
        static let medium: CGFloat = 8.0
        static let large: CGFloat = 12.0
        static let extraLarge: CGFloat = 20.0
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