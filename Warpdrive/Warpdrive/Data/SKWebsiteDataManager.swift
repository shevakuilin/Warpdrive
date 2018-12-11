//
//  SKWebsiteDataManager.swift
//  Warpdrive
//
//  菜单栏网站数据本地储存
//
//  Created by ShevaKuilin on 2018/12/11.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa

class SKWebsiteDataManager: NSObject {
    private static var _shareManager: SKWebsiteDataManager?
    
    class func shareManager() -> SKWebsiteDataManager {
        guard let instance = _shareManager else {
            _shareManager = SKWebsiteDataManager()
            return _shareManager!
        }
        return instance
    }
    
    class func destroy() {  /// 销毁单例
        _shareManager = nil
    }
    
    class func saveData(website: String, webName: String, webIcon: String) { /// 保存数据至本地沙盒
//        UserDefaults.standard.set(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
    }
    
    private override init() {}
}
