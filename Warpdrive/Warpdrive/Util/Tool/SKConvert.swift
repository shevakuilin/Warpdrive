//
//  SKConvert.swift
//  Warpdrive
//
//  Created by ShevaKuilin on 2018/12/20.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa

class SKConvert: NSObject {
    /// 将SKWebsiteInfo转换为Dictional
    class func convertWebsiteInfoToDic(websiteInfo: SKWebsiteInfo) -> [String:String] {
        let website = websiteInfo.website
        let webName = websiteInfo.webName
        let webIcon = websiteInfo.websiteIconUrl
        
        var dic = [String:String]()
        dic["website"] = website
        dic["webName"] = webName
        dic["webIcon"] = webIcon
        
        return dic
    }
    
    /// 将Dictional转换为SKWebsiteInfo
    class func convertDicToWebsiteInfo(dic: [String:String]) -> SKWebsiteInfo {
        let websiteInfo = SKWebsiteInfo()
        websiteInfo.website = dic["website"]
        websiteInfo.webName = dic["webName"]
        websiteInfo.websiteIconUrl = dic["webIcon"]
        
        return websiteInfo
    }
}
