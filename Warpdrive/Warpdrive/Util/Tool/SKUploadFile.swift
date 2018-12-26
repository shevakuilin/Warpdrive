//
//  SKUploadFile.swift
//  Warpdrive
//
//  Created by ShevaKuilin on 2018/12/26.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa

class SKUploadFile: NSObject {
    /// 选择图片文件 @return 图片，文件路径
    class func chooseImageFile(success: @escaping ((NSImage, String)) -> (), failure: @escaping () -> ()) {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "选择图片，目前仅支持png、jpeg和jpg格式图片"
        openPanel.allowedFileTypes = ["png", "jpeg", "jpg"]
        openPanel.directoryURL = nil
        
        openPanel.beginSheetModal(for: NSApplication.shared.keyWindow!) { (returnCode) in
            if returnCode.rawValue == 1 {
                guard let fileUrl = openPanel.urls.first else {
                    return
                }
                do {
                    let fileHandle = try FileHandle(forReadingFrom: fileUrl)
                    let imageData = fileHandle.readDataToEndOfFile()
                    let image = NSImage(data: imageData)
                    let fileContext = imageData.base64EncodedString(options: Data.Base64EncodingOptions())//imageData.map { String(format: "%02hhx", $0) }.joined()
                    if let theImage = image {
                        success((theImage, fileContext))
                    } else {
                        failure()
                    }
                } catch {
                    failure()
                }
            }
        }
    }
}
