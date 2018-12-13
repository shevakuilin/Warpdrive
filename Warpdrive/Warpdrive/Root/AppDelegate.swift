//
//  AppDelegate.swift
//  Warpdrive
//
//  Created by ShevaKuilin on 2018/12/7.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate  {

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength) /// 状态栏
    private let menu = NSMenu() /// 菜单栏
    private let popover = NSPopover()   /// 弹窗
    
    private var website: String?    /// 网站
    private var webName: String?    /// 站点名称
    private var websiteIconUrl: String? /// 网站icon
    private var websiteDataList: [[String : String]]? /// 网站列表数据
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initMenu()
        initPopover()
        loadWebsiteData()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

private extension AppDelegate {
    /// 初始化网站列表数据
    private func loadWebsiteData() {
        websiteDataList = SKWebsiteDataManager.readData()
        guard let dataList = websiteDataList else {
            return
        }
        guard dataList.count > 0 else {
            return
        }
        for dic in dataList {
            website = dic["website"]
            webName = dic["webName"]
            websiteIconUrl = dic["webIcon"]
            updateMenuList()
        }
    }
    
    /// 初始化菜单栏
    private func initMenu() {
        menu.addItem(withTitle: "添加的站点将在这里显示", action: nil, keyEquivalent: "")

        menu.addItem(.separator())
        
        menu.addItem(withTitle: "添加站点", action: #selector(addWebsite(sender:)), keyEquivalent: "A")
        
        let settingItem = NSMenuItem(title: "设置", action: #selector(setting), keyEquivalent: "")
        menu.addItem(settingItem)
        
        let subMenu = NSMenu()
        subMenu.addItem(withTitle: "编辑站点", action: #selector(websiteEdit), keyEquivalent: "")
        subMenu.addItem(.separator())
        subMenu.addItem(withTitle: "偏好设置", action: #selector(preferenceSetting), keyEquivalent: "")
        menu.setSubmenu(subMenu, for: settingItem)
        
        menu.addItem(.separator()) /// 分隔符
        menu.addItem(withTitle: "退出", action: #selector(quitApplication), keyEquivalent: "Q")

        statusItem.menu = menu
        if let button = statusItem.button {
            button.image = NSImage(named: "nav_icon")
//            button.action = #selector(closePopover)
        }
    }
    
    /// 初始化弹窗
    private func initPopover() {
        let addWebsiteVC = SKAddWebsiteViewController.loadFromStoryboard()
        addWebsiteVC.addCompletionDelegate.delegate(to: self) { (self, arg1) in
            self.website = arg1.0
            self.webName = arg1.1
            self.websiteIconUrl = arg1.2
            self.closePopover()
            self.updateMenuList()
        }
        popover.contentViewController = addWebsiteVC
    }
}

private extension AppDelegate {
    /// 关闭程序
    @objc private func quitApplication() {
        NSApp.terminate(self)
    }
    
    /// 设置
    @objc private func setting() {
        
    }
    
    /// 添加站点
    @objc private func addWebsite(sender: NSMenuItem) {
        showAddWebsitePopover(sender: sender)
    }
    
    /// 偏好设置
    @objc private func preferenceSetting() {
        
    }
    
    /// 编辑站点
    @objc private func websiteEdit() {
        
    }
}

private extension AppDelegate {
    /// 显示添加站点弹窗
    @objc private func showAddWebsitePopover(sender: Any) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            if let button = statusItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
    
    /// 关闭弹窗
    private func closePopover() {
        if popover.isShown {
            popover.close()
        }
    }
    
    /// 更新菜单列表
    private func updateMenuList() {
        if menu.items.first?.title == "添加的站点将在这里显示" {
            menu.removeItem(at: 0) /// 先移除顶部占位
        }
        guard let title = self.webName else {
            return
        }
        let item = NSMenuItem(title: title, action: #selector(menuItemAction), keyEquivalent: "")
        if let iconUrl = websiteIconUrl {
            if let imageData = Data(base64Encoded: iconUrl){
                item.image = NSImage(data: imageData)
            }
        }
        menu.insertItem(item, at: 0)
        
        /// TODO: 保存到沙盒，下次启动直接从沙盒中读取内容
        var dic = [String:String]()
        dic["website"] = website
        dic["webName"] = webName
        dic["webIcon"] = websiteIconUrl
        guard let dataList = websiteDataList else {
            return
        }
        if !dataList.contains(dic) {
            SKWebsiteDataManager.saveData(website: website, webName: webName, webIcon: websiteIconUrl)
        }
    }
    
    /// 点击菜单栏选项，打开浏览器跳转
    @objc private func menuItemAction() {
        guard let urlStr = self.website else {
            return
        }
        guard let url = URL(string: urlStr) else {
            return
        }
        NSWorkspace.shared.open(url)
    }
}

