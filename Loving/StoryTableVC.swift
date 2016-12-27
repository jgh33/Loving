//
//  StoryTableVC.swift
//  Loving
//
//  Created by 焦国辉 on 2016/12/4.
//  Copyright © 2016年 scau. All rights reserved.
//

import UIKit

let severUrlStr = "http://bc15387026.imwork.net/guohui/"
class StoryTableVC: UITableViewController
//, UITableViewDelegate, UITableViewDataSource 
{

//MARK:--属性
    @IBOutlet weak var playBtn: UIButton!

    
    private var storyofArray:[Story] = []
    private let path = NSHomeDirectory() + "/Documents/StoriesList.plist"

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.automaticallyAdjustsScrollViewInsets = false
        setPlayItemStatus()
        debugPrint(path)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setArr()
        self.tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }

    
    
// MARK: - 控件 Action
    @IBAction func update(_ sender: UIBarButtonItem) {
        let severUrl1 = severUrlStr + "StoriesList.plist"
        let severUrl2 = severUrlStr + "PoetriesList.plist"
        
        
        NetManager.download(urlStr: severUrl1, isShowHUB: false){
            self.setArr()
            self.tableView.reloadData()
        }
        NetManager.download(urlStr: severUrl2, completionHandler: nil)
        
    }
    
    private func setArr() {
        if let stories = NSArray(contentsOfFile: path){
            self.storyofArray = []
            for s in stories {
                self.storyofArray.append(Story(dict: s as! NSDictionary))
            }
        }
        
    }
    
    @IBAction func paly() {
        if (self.tabBarController as! JGHTabBarVC).isplaying {
            (self.tabBarController as! JGHTabBarVC).audioPlayer.pause()
        }else{
            (self.tabBarController as! JGHTabBarVC).audioPlayer.play()
        }
        (self.tabBarController as! JGHTabBarVC).isplaying = !(self.tabBarController as! JGHTabBarVC).isplaying
        setPlayItemStatus()
    }
    
    private func setPlayItemStatus()  {
        if (self.tabBarController as! JGHTabBarVC).isplaying{
            self.playBtn.setImage(UIImage(named: "hp_player_btn_pause_normal"), for: .normal)
            self.playBtn.setImage(UIImage(named: "hp_player_btn_pause_highlight"), for: .highlighted)
        }else{
            self.playBtn.setImage(UIImage(named: "hp_player_btn_play_normal"), for: .normal)
            self.playBtn.setImage(UIImage(named: "hp_player_btn_play_highlight"), for: .highlighted)
            
        }
    }



// MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
    

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
