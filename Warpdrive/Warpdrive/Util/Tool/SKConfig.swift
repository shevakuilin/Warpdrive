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
        if isMojave() {
            return NSImage(named: "nav_icon")!
        }
        return NSImage(named: "nav_balck_icon")!
    }
    
    /// 获取网站默认website
    class func gainWebsiteDefaultIcon() -> NSImage {
        if isMojave() {
            return NSImage(named: "link")!
        }
        return NSImage(named: "link_black")!
    }
    
    /// 判断系统是否是mojave
    class func isMojave() -> Bool {
        let info = ProcessInfo.processInfo
        if info.operatingSystemVersion.majorVersion >= 10 && info.operatingSystemVersion.minorVersion >= 14 {
            return true
        }
        return false
    }
}
