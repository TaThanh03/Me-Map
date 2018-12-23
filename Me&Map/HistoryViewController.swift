//
//  HistoryViewController.swift
//  Me&Map
//
//  Created by TA Trung Thanh on 20/12/2018.
//  Copyright © 2018 TA Trung Thanh. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {
    
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
        let buttonSave = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAddress(sender:)))
        self.navigationItem.rightBarButtonItem = buttonSave
    }
    
    @objc func saveAddress (sender: UIBarButtonItem) {
        print("saveAddress")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // TableViewDataSource protocol
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let tbc = self.tabBarController as? MyCustomTabController {
            return tbc.content.count
        }
        /*
        if let svc = self.splitViewController as? MyCustomSplitViewController {
            return svc.content.count
        }*/
        print("ERROR")
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tbc = self.tabBarController as? MyCustomTabController {
            return tbc.content[section].count
        }
        /*
        if let svc = self.splitViewController as? MyCustomSplitViewController {
            return svc.content[section].count
        }*/
        print("ERROR")
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "reusedCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        var cont : OneCell?
        if let tbc = self.tabBarController as? MyCustomTabController {
            cont = tbc.content[indexPath.section][indexPath.row]
        }
        /*
        if let svc = self.splitViewController as? MyCustomSplitViewController {
            cont = svc.content[indexPath.section][indexPath.row]
        }*/
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell!.textLabel?.text = cont!.label
        return cell!
    }
    
    //UITableViewDelegate protocol
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
}
