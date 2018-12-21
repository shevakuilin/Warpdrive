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
    
    public var addCompletionDelegate = Delegated<SKWebsiteInfo, Void>() /// 添加站点完成回调
    public var closePopoverDelegate = Delegated<Void, Void>()   /// 关闭窗口
    
    class func loadFromStoryboard() -> SKAddWebsiteViewController {
        let stroyboard = NSStoryboard(name: "Main", bundle: nil)
        return stroyboard.instantiateController(withIdentifier: "SKAddWebsiteViewController") as! SKAddWebsiteViewController
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initElements()
//        setMouseAction()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        cleanData()
    }
    
    /// 点击添加按钮
    @IBAction func clickAdd(_ sender: Any) {
        guard !textFieldErrorHandle() else {
            return
        }
        if addCompletionDelegate.isDelegateSet {
            let websiteInfo = SKWebsiteInfo()
            websiteInfo.website = self.websiteTextField.stringValue
            websiteInfo.webName = self.webNameTextField.stringValue
            websiteInfo.websiteIconUrl = self.webIconDataStr
            addCompletionDelegate.call(websiteInfo)
        }
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
    private func initElements() {
        self.websiteTextField.placeholderAttributedString = kAttributedStyle("网址", self.websiteTextField.font!, kColor(88, 86, 92), .left, 5)
        self.webNameTextField.placeholderAttributedString = kAttributedStyle("站点名称", self.websiteTextField.font!, kColor(88, 86, 92), .left, 5)
        self.websiteTextField.delegate = self
        self.webNameTextField.delegate = self
    }
}

private extension SKAddWebsiteViewController {
    /// 清空页面数据
    private func cleanData() {
        websiteTextField.resignFirstResponder()
        websiteTextField.attributedStringValue = NSAttributedString(string: "")
        webNameTextField.resignFirstResponder()
        webNameTextField.attributedStringValue = NSAttributedString(string: "")
        webIcon.image = nil
        webIconDataStr = nil
    }
    
    /// 错误状态处理
    private func textFieldErrorHandle() -> Bool {
        if self.websiteTextField.stringValue == "" {
            self.websiteTextField.placeholderAttributedString = kAttributedStyle("网址不能为空", self.websiteTextField.font!, kColor(88, 86, 92), .left, 5)
            return true
        }
        if self.webNameTextField.stringValue == "" {
            self.webNameTextField.placeholderAttributedString = kAttributedStyle("请填写站点名称", self.websiteTextField.font!, kColor(88, 86, 92), .left, 5)
            return true
        }
        if self.websiteTextField.placeholderAttributedString?.string == "网址不能为空" || self.webNameTextField.placeholderAttributedString?.string == "请填写站点名称" {
            return true
        }
        return false
    }
}

extension SKAddWebsiteViewController: NSTextFieldDelegate {
    func controlTextDidBeginEditing(_ obj: Notification) {
        guard let field = obj.object as? NSTextField else {
            return
        }
        if field == self.websiteTextField {
            self.websiteTextField.placeholderAttributedString = kAttributedStyle("网址", self.websiteTextField.font!, kColor(88, 86, 92), .left, 5)
        } else {
            self.webNameTextField.placeholderAttributedString = kAttributedStyle("站点名称", self.websiteTextField.font!, kColor(88, 86, 92), .left, 5)
        }
    }
}
