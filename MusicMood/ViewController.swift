//
//  ViewController.swift
//  MusicMood
//
//  Created by Ivan Rzhanoi on 22/09/2016.
//  Copyright © 2016 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer

class ViewController: UIViewController {
    
    //let player = AVPlayer()
    var player = MPMusicPlayerController()
    

    
    
    @IBOutlet weak var currentMood: UILabel!
    @IBAction func playPause(_ sender: AnyObject) {
        player.play()
        /*if player.playbackState != 1.0 {
            currentMood.text = "rarar"
            player.play()
        }
        else {
            // Playing, so pause.
            currentMood.text = "Static"
            player.pause()
        }*/
    }
    @IBAction func next(_ sender: AnyObject) {
        // For now for testing it is pausing
        player.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        player = MPMusicPlayerController.applicationMusicPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

