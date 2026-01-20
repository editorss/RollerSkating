//
//  UIColor+Hex.swift
//  RollerSkating
//
//  UIColor Hex 颜色扩展
//

import UIKit

extension UIColor {
    
    /// 通过 Hex 字符串创建颜色
    /// - Parameter hex: Hex 字符串，支持 #RRGGBB 或 RRGGBB 格式
    /// - Parameter alpha: 透明度，默认 1.0
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 通过 Hex 数值创建颜色
    /// - Parameter hex: Hex 数值，如 0x7F55B2
    /// - Parameter alpha: 透明度，默认 1.0
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
