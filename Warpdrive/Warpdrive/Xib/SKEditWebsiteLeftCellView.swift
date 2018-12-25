//
//  SKEditWebsiteLeftCellView.swift
//  Warpdrive
//
//  Created by ShevaKuilin on 2018/12/21.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa

class SKEditWebsiteLeftCellView: NSView {

    @IBOutlet weak var webIcon: NSImageView!
    @IBOutlet weak var webName: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
        webIcon.wantsLayer = true
        webIcon.layer?.cornerRadius = webIcon.frame.size.height/2
    }
    
    /// 设置数据
    public func setData(_ info: SKWebsiteInfo) {
        webIcon.imageScaling = .scaleProportionallyDown
        if let iconUrl = info.websiteIconUrl {
            if let imageData = Data(base64Encoded: iconUrl) {
                if let image = NSImage(data: imageData) {
                    webIcon.image = image
                }
            }
        } else {
            webIcon.image = SKConfig.gainWebsiteDefaultIcon()
        }
        webName.stringValue = info.webName ?? ""
    }
    
}
