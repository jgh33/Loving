//
//  JGHTabBarVC.swift
//  Loving
//
//  Created by 焦国辉 on 2016/12/4.
//  Copyright © 2016年 scau. All rights reserved.
//

import UIKit
import AVFoundation

class JGHTabBarVC: UITabBarController {
    
    var audioPlayer: AVAudioPlayer!
    var isplaying = false
    let song = "I Believe"
    let path = Bundle.main.url(forResource: "I Believe", withExtension:  "mp3")


    override func viewDidLoad() {
        super.viewDidLoad()
        try! self.audioPlayer = AVAudioPlayer(contentsOf: path!)
        self.audioPlayer.numberOfLoops = -1 //－1为循环播放
        audioPlayer.play()
        self.isplaying = true
        

    }

    

}
