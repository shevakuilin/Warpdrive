//
//  AppDelegate.swift
//  Warpdrive
//
//  Created by ShevaKuilin on 2018/12/7.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate  {

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength) /// 状态栏
    private let menu = NSMenu()         /// 菜单栏
    private let popover = NSPopover()   /// 弹窗
    
    private let itemTitlePrefix = " "
    private var editWebsiteWindowController = SKEditWebsiteWindowController() /// 编辑网站弹窗
    
    private var websiteDataList: [SKWebsiteInfo]? /// 网站列表数据
    private lazy var websiteInfo = SKWebsiteInfo().then { _ in }    /// 网站信息
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        bootUp()
        initMenu()
        initPopover()
        initEditWindow()
        loadWebsiteData()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

private extension AppDelegate {
    /// 开机启动
    private func bootUp() {
        let launcherApplicationIdentifier = "SK.LauncherApplication"
        SMLoginItemSetEnabled(launcherApplicationIdentifier as CFString, true)
        
        var startedAtLogin = false
        for app in NSWorkspace.shared.runningApplications {
            if app.bundleIdentifier == launcherApplicationIdentifier {
                startedAtLogin = true
            }
        }
        
        if startedAtLogin {
            DistributedNotificationCenter.default().post(name: kNotificationName("killhelper"), object: Bundle.main.bundleIdentifier!)
        }
    }
}

private extension AppDelegate {
    /// 初始化网站列表数据
    private func loadWebsiteData() {
        let localDataList = SKWebsiteDataManager.readData()
        /// 倒序输出
        var reverseList = [SKWebsiteInfo]()
        for info in localDataList.reversed() {
            reverseList.append(info)
        }
        websiteDataList = reverseList
        guard let dataList = websiteDataList else {
            return
        }
        guard dataList.count > 0 else {
            return
        }
        updateMenuList(websiteDataList)
    }
    
    /// 初始化菜单栏
    private func initMenu() {
        menu.addItem(withTitle: "添加的站点将在这里显示", action: nil, keyEquivalent: "")

        menu.addItem(.separator())
        
        menu.addItem(withTitle: "添加站点", action: #selector(addWebsite(sender:)), keyEquivalent: "a")
        
        let settingItem = NSMenuItem(title: "设置", action: #selector(setting), keyEquivalent: "")
        menu.addItem(settingItem)
        
        let subMenu = NSMenu()
        subMenu.addItem(withTitle: "编辑站点", action: #selector(websiteEdit), keyEquivalent: "e")
        subMenu.addItem(.separator())
        subMenu.addItem(withTitle: "清空站点", action: #selector(cleanAllWebsite), keyEquivalent: "c")
        subMenu.addItem(.separator())
        subMenu.addItem(withTitle: "偏好设置", action: #selector(preferenceSetting), keyEquivalent: "s")
        menu.setSubmenu(subMenu, for: settingItem)
        
        menu.addItem(.separator()) /// 分隔符
        menu.addItem(withTitle: "退出", action: #selector(quitApplication), keyEquivalent: "q")

        statusItem.menu = menu
        if let button = statusItem.button {
            button.image = SKConfig.gainStatusItemButtonIcon()
//            button.action = #selector(closePopover)
        }
    }
    
    /// 初始化弹窗
    private func initPopover() {
        let addWebsiteVC = SKAddWebsiteViewController.loadFromStoryboard()
        addWebsiteVC.addCompletionDelegate.delegate(to: self) { (self, info) in
            /// 关闭弹窗
            self.closePopover()
            /// 更新数据
            self.websiteDataList = SKWebsiteDataManager.updateData(websiteInfo: info)
            /// 更新菜单列表
            guard let dataList = self.websiteDataList else {
                return
            }
//            dataList.append(info)
            self.updateMenuList(dataList)
        }
        popover.contentViewController = addWebsiteVC
    }
    
    private func initEditWindow() {
        editWebsiteWindowController = SKEditWebsiteWindowController.loadFromNib()
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
        editWebsiteWindowController.dismissController(nil)
        editWebsiteWindowController.showWindow(nil)
    }
    
    /// 清空站点
    @objc private func cleanAllWebsite() {
        let alert = NSAlert()
        alert.messageText = "确认要清空列表中的站点吗？"
        alert.informativeText = "注意：此操作将不可恢复"
        alert.addButton(withTitle: "确认清除")
        alert.addButton(withTitle: "取消")
        alert.alertStyle = .warning
        let action = alert.runModal()
        if action == .alertFirstButtonReturn {
            printLog("清空全部站点数据")
            /// 清除全部数据
            SKWebsiteDataManager.removeAllData()
            /// 清除全部菜单子项
            menu.removeAllItems()
            /// 初始化菜单
            initMenu()
        } else if action == .alertSecondButtonReturn {
            printLog("取消清空操作")
        }
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
    
    /// 创建一个菜单子项
    private func creatMenuItem(info: SKWebsiteInfo) -> NSMenuItem? {
        if var title = info.webName {
            title = itemTitlePrefix + title
            let item = NSMenuItem(title: title, action: #selector(menuItemAction), keyEquivalent: "")
            if let iconUrl = info.websiteIconUrl {
                if let imageData = Data(base64Encoded: iconUrl) {
                    if let image = NSImage(data: imageData) {
                        item.image = resize(image: image, w: 18, h: 18)
                    }
                }
            } else {
                item.image = SKConfig.gainWebsiteDefaultIcon()
            }
            
            return item
        }
        return nil
    }
    
    /// 更新菜单列表
    private func updateMenuList(_ dataList: [SKWebsiteInfo]?) {
        if menu.items.first?.title == "添加的站点将在这里显示" {
            menu.removeItem(at: 0) /// 先移除顶部占位
        }
        guard let newItemList = dataList else {
            return
        }
        for newItem in newItemList {
            var isExist = false
            for menuItem in menu.items {
                if menuItem.title == newItem.webName {
                    isExist = true
                    break
                }
            }
            /// 如果当前菜单中不存在相同的子项，就插入菜单
            if !isExist {
                if let item = creatMenuItem(info: newItem) {
                    menu.insertItem(item, at: 0)
                }
            }
        }
    }
    
    /// 恢复默认菜单列表
    private func restoreDefaultMenuList() {
        
    }
    
    /// 点击菜单栏选项，打开浏览器跳转
    @objc private func menuItemAction(sender: NSMenuItem) {
        guard let dataList = websiteDataList else {
            return
        }
        /// 过滤出于菜单子项相对应的链接
        let index = sender.title.index(sender.title.startIndex, offsetBy: itemTitlePrefix.count)
        let originalTitle: String = String(sender.title.suffix(from: index))
        let websiteList = dataList.filter { $0.webName == originalTitle }
        guard let urlStr = websiteList.first?.website else {
            return
        }
        guard let url = URL(string: urlStr) else {
            return
        }
        NSWorkspace.shared.open(url)
    }
}

private extension AppDelegate {
    /// 修改图片尺寸以适应菜单栏大小
    private func resize(image: NSImage, w: Int, h: Int) -> NSImage? {
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let newImage = NSImage(size: destSize)
        let imageFrame = kFrame(0, 0, destSize.width, destSize.height)
        
        newImage.lockFocus()
        /// 裁剪圆角
        NSGraphicsContext.saveGraphicsState()
        let path = NSBezierPath(roundedRect: imageFrame, xRadius: image.size.width/2, yRadius: image.size.height/2)
        path.addClip()
        image.draw(in: imageFrame, from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: .sourceOver, fraction: CGFloat(1))
        NSGraphicsContext.restoreGraphicsState()
        newImage.unlockFocus()
        
        newImage.size = destSize
        guard let tiffRepresentation = newImage.tiffRepresentation else {
            return nil
        }
        return NSImage(data: tiffRepresentation)
    }
}
