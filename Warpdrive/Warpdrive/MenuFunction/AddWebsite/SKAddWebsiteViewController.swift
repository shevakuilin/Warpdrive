//
//  SKAddWebsiteViewController.swift
//  Warpdrive
//
//  添加站点
//
//  Created by ShevaKuilin on 2018/12/10.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa

class SKAddWebsiteViewController: NSViewController {

    @IBOutlet weak var websiteTextField: NSTextField!   /// 网址
    @IBOutlet weak var webNameTextField: NSTextField!   /// 站点名称
    @IBOutlet weak var webIcon: NSButton!               /// 网站icon
    private var webIconDataStr: String?                 /// 网站icon图片data字符
    
    public var addCompletionDelegate = Delegated<(String, String, String), Void>() /// 添加站点完成回调
    
    class func loadFromStoryboard() -> SKAddWebsiteViewController {
        let stroyboard = NSStoryboard(name: "Main", bundle: nil)
        return stroyboard.instantiateController(withIdentifier: "SKAddWebsiteViewController") as! SKAddWebsiteViewController
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setMouseAction()
    }
    
    /// 点击添加按钮
    @IBAction func clickAdd(_ sender: Any) {
        guard !textFieldErrorHandle() else {
            return
        }
        if addCompletionDelegate.isDelegateSet {
            addCompletionDelegate.call((self.websiteTextField.stringValue, self.webNameTextField.stringValue, self.webIconDataStr ?? ""))
        }
//        updateMenuList { [weak self] (completion) in
//            guard let strongSelf = self else {
//                return
//            }
//            if completion {
//                strongSelf.closePopover()
//            }
//        }
    }
    
    /// 点击上传图片
    @IBAction func clickUploadImage(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "选择图片，目前仅支持png、jpeg和jpg格式图片"
        openPanel.allowedFileTypes = ["png", "jpeg", "jpg"]
        openPanel.directoryURL = nil
        
        openPanel.beginSheetModal(for: NSApplication.shared.keyWindow!) { [weak self] (returnCode) in
            guard let strongSelf = self else {
                return
            }
            if returnCode.rawValue == 1 {
                guard let fileUrl = openPanel.urls.first else {
                    return
                }
                do {
                    let fileHandle = try FileHandle(forReadingFrom: fileUrl)
                    let imageData = fileHandle.readDataToEndOfFile()
                    strongSelf.webIcon.image = NSImage(data: imageData)
//                    let fileContext = String(data: imageData, encoding: .utf8)
                    
                    let fileContext = imageData.base64EncodedString(options: Data.Base64EncodingOptions())//imageData.map { String(format: "%02hhx", $0) }.joined()
                    strongSelf.webIconDataStr = fileContext
                } catch {
                    
                }
            }
        }
    }
    
//    /// 监听鼠标点击区域不在弹窗范围内，弹窗消失
//    private func setMouseAction() {
//        let area:NSTrackingArea = NSTrackingArea.init(rect: self.view.bounds, options: [.mouseEnteredAndExited, .activeInKeyWindow], owner: self, userInfo: nil)
//        self.view.addTrackingArea(area)
//    }
//
//    /// 鼠标点击
//    override func mouseDown(with event: NSEvent) {
//        let eventLocation = event.locationInWindow
//        print("在window中的坐标为 \(eventLocation)")
//        let center = self.view.convert(eventLocation, to: nil)
//    }
    
}

private extension SKAddWebsiteViewController {
    /// 错误状态处理
    private func textFieldErrorHandle() -> Bool {
        if self.websiteTextField.stringValue == "" {
            self.websiteTextField.stringValue = "网址不能为空"
            self.websiteTextField.textColor = .red
            return true
        }
        if self.webNameTextField.stringValue == "" {
            self.webNameTextField.stringValue = "请填写站点名称"
            self.websiteTextField.textColor = .red
            return true
        }
        if self.websiteTextField.stringValue == "网址不能为空" || self.webNameTextField.stringValue == "请填写站点名称" {
            return true
        }
        return false
    }
}

extension SKAddWebsiteViewController: NSControlTextEditingDelegate {
    func controlTextDidBeginEditing(_ obj: Notification) {
        guard let field = obj.object as? NSTextField else {
            return
        }
        if field == self.websiteTextField {
            self.websiteTextField.textColor = .white
        } else {
            self.webNameTextField.textColor = .white
        }
    }
}
