//
//  HistoryViewController.swift
//  Me&Map
//
//  Created by TA Trung Thanh on 20/12/2018.
//  Copyright © 2018 TA Trung Thanh. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {
    private let rep = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    private var thePath = ""
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.tableView.separatorColor = .clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let tbi = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        self.tabBarItem = tbi
        self.title = "History" //used by the navigation controller
        self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        let buttonSave = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveData(sender:)))
        self.navigationItem.rightBarButtonItem = buttonSave
        
        thePath = rep[0] + "/meAndMapLocations"
    }
    
    @objc func saveData (sender: UIBarButtonItem) {
        print("saveData")
        let coder = NSKeyedArchiver(requiringSecureCoding: false)
        
        var content = [OneCell]()
        if let tbc = self.tabBarController as? MyCustomTabController {
            content = tbc.content
        }
        if let svc = self.splitViewController as? MyCustomSplitViewController {
            content = svc.content
        }
        coder.encode(content, forKey: NSKeyedArchiveRootObjectKey)
        FileManager.default.createFile(atPath: thePath, contents: coder.encodedData, attributes: [:])
    }
    
    func loadData() {
        //Fetch data
        if FileManager.default.fileExists(atPath: thePath) {
            let data = FileManager.default.contents(atPath: thePath)
            if data != nil {
                do {
                    let decoder = try NSKeyedUnarchiver(forReadingFrom: data!)
                    decoder.requiresSecureCoding = false
                    let d = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as? [OneCell]
                    if let tbc = self.tabBarController as? MyCustomTabController {
                        tbc.content = d!
                    }
                    if let svc = self.splitViewController as? MyCustomSplitViewController {
                        svc.content = d!
                    }
                } catch {
                    print("Decoding failed!!!")
                }
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        self.tableView.reloadData()
    }
    
    // TableViewDataSource protocol
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let tbc = self.tabBarController as? MyCustomTabController {
            return tbc.content.count
        }
        if let svc = self.splitViewController as? MyCustomSplitViewController {
            return svc.content.count
        }
        print("ERROR")
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "reusedCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        var cont : OneCell?
        if let tbc = self.tabBarController as? MyCustomTabController {
            cont = tbc.content[indexPath.section]
        } else if let svc = self.splitViewController as? MyCustomSplitViewController {
            cont = svc.content[indexPath.section]
        } else {
            print("cellForRowAt ERROR")
        }
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell!.textLabel?.text = cont!.address
        return cell!
    }
    
    //UITableViewDelegate protocol
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        if let tbc = self.tabBarController as? MyCustomTabController {
            tbc.index = indexPath.section
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMap"), object: nil)
        } else if let svc = self.splitViewController as? MyCustomSplitViewController {
            svc.index = indexPath.section
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMap"), object: nil)
        }
    }
}

