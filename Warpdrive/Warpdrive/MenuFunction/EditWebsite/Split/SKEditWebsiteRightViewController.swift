//
//  SKEditWebsiteRightViewController.swift
//  Warpdrive
//
//  Created by ShevaKuilin on 2018/12/22.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa

class SKEditWebsiteRightViewController: NSViewController {

    @IBOutlet weak var websiteTextField: NSTextField!
    @IBOutlet weak var webNameTextField: NSTextField!
    @IBOutlet weak var webIconImageView: NSButton!
    
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var confirmButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initElements()
        defaultData()
        registerNotification()
    }
    
    deinit {
        destroyNotification()
    }
    
}

private extension SKEditWebsiteRightViewController {
    private func initElements() {
        webIconImageView.imageScaling = .scaleProportionallyDown
        confirmButton.highlight(true)
    }
    
    private func defaultData() {
        let dataList = SKWebsiteDataManager.readData()
        guard let info = dataList.first else {
            return
        }
        websiteTextField.stringValue = info.website ?? ""
        webNameTextField.stringValue = info.webName ?? ""
        
        if let websiteIconUrl = info.websiteIconUrl {
            if let imageData = Data(base64Encoded: websiteIconUrl) {
                if let image = NSImage(data: imageData) {
                    webIconImageView.image = image
                }
            }
        } else {
            webIconImageView.image = SKConfig.gainWebsiteDefaultIcon()
        }
    }
}

private extension SKEditWebsiteRightViewController {
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(noti:)), name: kNotificationName("SelectedWebname"), object: nil)
    }
    
    private func destroyNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 更新数据
    @objc private func updateData(noti: Notification) {
        guard let userInfo = noti.userInfo else {
            return
        }

        let website = userInfo["website"] as! String
        let webName = userInfo["webName"] as! String
        websiteTextField.stringValue = website
        webNameTextField.stringValue = webName
        
        if let websiteIconUrl: String = userInfo["webIcon"] as? String {
            if let imageData = Data(base64Encoded: websiteIconUrl) {
                if let image = NSImage(data: imageData) {
                    webIconImageView.image = image
                }
            }
        } else {
            webIconImageView.image = SKConfig.gainWebsiteDefaultIcon()
        }
        
        
    }
}
