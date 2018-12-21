//
//  SKEditWebsiteViewController.swift
//  Warpdrive
//
//  编辑站点
//
//  Created by ShevaKuilin on 2018/12/21.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa

class SKEditWebsiteViewController: NSSplitViewController {
    
    class func loadFromNib() -> SKEditWebsiteViewController {
        let stroyboard = NSStoryboard(name: "Main", bundle: nil)
        return stroyboard.instantiateController(withIdentifier: "SKEditWebsiteViewController") as! SKEditWebsiteViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
