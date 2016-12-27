//
//  PoetryTableVC.swift
//  Loving
//
//  Created by 焦国辉 on 2016/12/5.
//  Copyright © 2016年 scau. All rights reserved.
//

import UIKit

class PoetryTableVC: UITableViewController {
//MARK:--属性
    private var storyofArray:[Story] = []
    private let path = NSHomeDirectory() + "/Documents/PoetriesList.plist"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setArr()
        self.tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setArr() {
        if let stories = NSArray(contentsOfFile: path){
            self.storyofArray = []
            for s in stories {
                self.storyofArray.append(Story(dict: s as! NSDictionary))
            }
        }
        
    }
    
   

// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.storyofArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.storyofArray[indexPath.row].title
        cell.detailTextLabel?.text = self.storyofArray[indexPath.row].time

        return cell
    }
 
// MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let story = storyofArray[indexPath.row]
        let storyBoard = UIStoryboard(name: "Story", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "JGHDetailViewController") as! JGHDetailViewController
        detailVC.story = story
        
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
