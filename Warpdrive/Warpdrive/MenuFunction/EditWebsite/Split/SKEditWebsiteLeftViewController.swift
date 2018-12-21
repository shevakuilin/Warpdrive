//
//  SKEditWebsiteLeftViewController.swift
//  Warpdrive
//
//  Created by ShevaKuilin on 2018/12/21.
//  Copyright © 2018 ShevaKuilin. All rights reserved.
//

import Cocoa

class SKEditWebsiteLeftViewController: NSViewController {

    @IBOutlet weak var bottomToolView: NSView!
    @IBOutlet weak var tableView: NSTableView!
    
    private var dataList = [SKWebsiteInfo]()    /// 数据源
    private let reuseCellKey:String = "SKEditWebsiteLeftCellView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initElements()
        lodaDataList()
    }
    
    @IBAction func addButtonClick(_ sender: Any) {
        
    }
    
    @IBAction func removeButtonClick(_ sender: Any) {
    }
}

private extension SKEditWebsiteLeftViewController {
    private func initElements() {
        bottomToolView.wantsLayer = true
        bottomToolView.layer?.backgroundColor = SKConfig.isMojaveDark() ? kColor(0, 0, 0, 0.3).cgColor:kColor(255, 255, 255, 0.3).cgColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 25
        registerCell()
    }
    
    private func registerCell() {
        if let cellView = NSNib(nibNamed: "SKEditWebsiteLeftCellView", bundle: nil) {
            tableView.register(cellView, forIdentifier: NSUserInterfaceItemIdentifier(rawValue: reuseCellKey))
        }
    }
    
    private func lodaDataList() {
        dataList = SKWebsiteDataManager.readData()
        tableView.reloadData()
    }
}

extension SKEditWebsiteLeftViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataList.count
    }
}

extension SKEditWebsiteLeftViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: reuseCellKey), owner: nil) as! SKEditWebsiteLeftCellView
        cell.setData(dataList[row])

        return cell
    }
}
