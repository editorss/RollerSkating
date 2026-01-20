//
//  UIImage+RS.swift
//  RollerSkating
//
//  Image helper
//

import UIKit

extension UIImage {
    
    /// 加载图片：支持 Assets 资源名、Documents 目录文件名、完整路径
    static func rs_load(_ nameOrPath: String?) -> UIImage? {
        guard let value = nameOrPath, !value.isEmpty else { return nil }
        
        // 处理 file:// URL
        if value.hasPrefix("file://") {
            let path = URL(string: value)?.path ?? value
            return UIImage(contentsOfFile: path)
        }
        
        // 处理 rs_post_ 开头的文件名（用户发布的动态图片）
        if value.hasPrefix("rs_post_") {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fullPath = documentsPath.appendingPathComponent(value).path
            if FileManager.default.fileExists(atPath: fullPath) {
                return UIImage(contentsOfFile: fullPath)
            }
        }
        
        // 处理 rs_avatar_ 开头的文件名（用户自定义头像）
        if value.hasPrefix("rs_avatar_") {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fullPath = documentsPath.appendingPathComponent(value).path
            if FileManager.default.fileExists(atPath: fullPath) {
                return UIImage(contentsOfFile: fullPath)
            }
        }
        
        // 处理完整路径（向后兼容）
        if value.contains("/") {
            if FileManager.default.fileExists(atPath: value) {
                return UIImage(contentsOfFile: value)
            }
        }
        
        // 默认从 Assets 加载
        return UIImage(named: value)
    }
}
