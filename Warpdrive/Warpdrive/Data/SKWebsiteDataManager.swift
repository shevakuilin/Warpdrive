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
//    private static var _shareManager: SKWebsiteDataManager?
//
//    class func shareManager() -> SKWebsiteDataManager {
//        guard let instance = _shareManager else {
//            _shareManager = SKWebsiteDataManager()
//            return _shareManager!
//        }
//        return instance
//    }
//
//    /// 销毁单例
//    class func destroy() {
//        _shareManager = nil
//    }
    
    /// 保存数据至本地沙盒
    class func saveData(websiteInfo: SKWebsiteInfo) {
        guard websiteInfo.website != "" && websiteInfo.website != nil else {
            printLog("保存网站列表数据失败，站点名称不能为空")
            return
        }
        guard websiteInfo.webName != "" && websiteInfo.website != nil else {
            printLog("保存网站列表数据失败，网站地址不能为空")
            return
        }
        let info = websiteInfo
        
        /// 读取本地已存入的数据列表
        var dataList = readData()
        /// 添加到列表末尾
        dataList.append(info)
        
        /// 保存数据至本地
        resetData(dataList: dataList)
        printLog("保存网站列表数据成功")
    }
    
    /// 更新本地沙盒的网站列表数据，并返回一个含有新插入数据的数据列表
    class func updateData(websiteInfo: SKWebsiteInfo) -> [SKWebsiteInfo] {
        saveData(websiteInfo: websiteInfo)
        return readData()
    }
    
    /// 更新指定下标的网站列表数据
    class func updateData(index: Int, replaceInfo: SKWebsiteInfo) {
        var dataList = readData()
        guard dataList.count > 0 else {
            return
        }
        dataList[index] = replaceInfo
        resetData(dataList: dataList)
        printLog("指定下标网站列表数据更新成功")
    }
    
    /// 重置本地沙盒的网站列表数据
    class func resetData(dataList: [SKWebsiteInfo]) {
        let list = dataList.map { (info) -> [String:String] in
            return SKConvert.convertWebsiteInfoToDic(websiteInfo: info)
        }
        UserDefaults.standard.set(list, forKey: "DataList")
        UserDefaults.standard.synchronize()
        printLog("本地沙盒的网站列表数据重置成功")
    }
    
    /// 读取网站列表数据
    class func readData() -> [SKWebsiteInfo] {
        let dataList: [[String:String]] = UserDefaults.standard.object(forKey: "DataList") as? [[String : String]] ?? [[String:String]]()
        let convertDataList = dataList.map { (result) -> SKWebsiteInfo in
            return SKConvert.convertDicToWebsiteInfo(dic: result)
        }
        return convertDataList
    }
    
    /// 读取网站列表数据数量
    class func readDataCount() -> Int {
        let dataList = readData()
        return dataList.count
    }
    
    /// 查询指定网站在本地沙盒数据列表中的下标，返回包含查询状态以及下标的元组
    class func queryIndex(websiteInfo: SKWebsiteInfo) -> (Bool, Int) {
        let dataList = readData()
        guard dataList.count > 0 else {
            printLog("查询指定下标失败")
            return (false, 0)
        }
        for info in dataList {
            if info.webName == websiteInfo.webName {
                if let index = dataList.index(of: info) {
                    printLog("查询指定下标成功")
                    return (true, index)
                }
            }
        }
        printLog("查询指定下标失败")
        return (false, 0)
    }
    
    /// 清除全部网站列表数据
    class func removeAllData() {
        UserDefaults.standard.removeObject(forKey: "DataList")
        UserDefaults.standard.synchronize()
    }
    
    /// 清除指定下标的网站列表数据
    class func removeData(index: Int) {
        var dataList: [[String:String]] = UserDefaults.standard.object(forKey: "DataList") as! [[String : String]]
        guard dataList.count > index else {
            printLog("清除制定下标的网站列表数据失败")
            return
        }
        dataList.remove(at: index)
        let filterDataList = dataList.map { (result) -> SKWebsiteInfo in
            return SKConvert.convertDicToWebsiteInfo(dic: result)
        }
        /// 重新覆盖本地数据
        resetData(dataList: filterDataList)
        printLog("清除制定下标的网站列表数据成功")
    }
    
    /// 清除指定站点名称的列表数据
    class func removeData(webName: String) {
        var dataList: [[String:String]] = UserDefaults.standard.object(forKey: "DataList") as! [[String : String]]
        guard dataList.count > 0 else {
            printLog("清除指定站点名称的列表数据失败")
            return
        }
        /// 遍历包含该站点名称的数据，删除
        for dic in dataList {
            if dic.keys.contains(webName) {
                if let index = dataList.index(of: dic) {
                    dataList.remove(at: index)
                    break
                }
            }
        }
        let filterDataList = dataList.map { (result) -> SKWebsiteInfo in
            return SKConvert.convertDicToWebsiteInfo(dic: result)
        }
        resetData(dataList: filterDataList)
        printLog("清除指定站点名称的列表数据成功")
    }
    
//    private override init() {}
}
