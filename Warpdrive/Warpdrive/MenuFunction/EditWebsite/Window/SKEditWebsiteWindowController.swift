//
//  SKEditWebsiteWindowController.swift
//  Warpdrive
//
//  Created by ShevaKuilin on 2018/12/21.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa

class SKEditWebsiteWindowController: NSWindowController {
    
    class func loadFromNib() -> SKEditWebsiteWindowController {
        let stroyboard = NSStoryboard(name: "Main", bundle: nil)
        return stroyboard.instantiateController(withIdentifier: "SKEditWebsiteWindowController") as! SKEditWebsiteWindowController
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
