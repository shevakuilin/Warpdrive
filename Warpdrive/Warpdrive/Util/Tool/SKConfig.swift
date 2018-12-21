//
//  SKConfig.swift
//  Warpdrive
//
//  Created by ShevaKuilin on 2018/12/21.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa

class SKConfig: NSObject {
    /// 获取状态栏按钮icon
    class func gainStatusItemButtonIcon() -> NSImage {
        if isMojaveDark() {
            return NSImage(named: "nav_icon")!
        }
        return NSImage(named: "nav_balck_icon")!
    }
    
    /// 获取网站默认website
    class func gainWebsiteDefaultIcon() -> NSImage {
        if isMojaveDark() {
            return NSImage(named: "link")!
        }
        return NSImage(named: "link_black")!
    }
    
    /// 判断系统是否是Mojave Dark主题
    class func isMojaveDark() -> Bool {
        if #available(macOS 10.14, *) {
            if NSAppearance.current.name.rawValue == "NSAppearanceNameDarkAqua" {
                return true
            }
            return false
        } else {
            return false
        }
    }
}
