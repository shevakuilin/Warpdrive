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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initMenu()    /// 初始化菜单栏
        initPopover() /// 初始化弹窗
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

private extension AppDelegate {
    private func initMenu() {
        menu.addItem(withTitle: "添加的站点将在这里显示", action: nil, keyEquivalent: "")

        menu.addItem(.separator())
        
        menu.addItem(withTitle: "添加站点", action: #selector(addWebsite(sender:)), keyEquivalent: "A")
        menu.addItem(withTitle: "设置", action: #selector(setting), keyEquivalent: ",")
        menu.addItem(.separator()) /// 分隔符
        menu.addItem(withTitle: "退出", action: #selector(quitApplication), keyEquivalent: "Q")

        statusItem.menu = menu
        if let button = statusItem.button {
            button.image = NSImage(named: "nav_icon")
//            button.action = #selector(closePopover)
        }
    }
    
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
        menu.insertItem(withTitle: title, action: #selector(menuItemAction), keyEquivalent: "", at: 0)
        
        /// TODO: 保存到沙盒，下次启动直接从沙盒中读取内容
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

