//
//  ViewController.swift
//  SwiftVideoPlayer
//
//  Created by hapsidra on 05/16/2018.
//  Copyright (c) 2018 hapsidra. All rights reserved.
//

import UIKit
import SwiftVideoPlayer

class ViewController: UIViewController {
    var player: PlayerVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        player = PlayerVC([URL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4")!])
        self.player.view.frame = CGRect(x: 50, y: 50, width: view.frame.width - 100, height: view.frame.height - 100)
        
        self.addChildViewController(player)
        self.view.addSubview(player.view)
        self.player.didMove(toParentViewController: self)
    }
}

