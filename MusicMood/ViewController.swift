//
//  ViewController.swift
//  MusicMood
//
//  Created by Ivan Rzhanoi on 22/09/2016.
//  Copyright © 2016 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, MPMediaPickerControllerDelegate {
    
    //let player = AVPlayer()
    var player = MPMusicPlayerController()
    var album = MPMediaItemPropertyAlbumTitle
    //var mood = MPMediaItemPropertyUserGrouping
    var mood = MPMediaItemPropertyComments
    
    
    
    @IBOutlet weak var currentMood: UILabel!
    
    @IBAction func pick(_ sender: AnyObject) {
        // Useless for now
        /*
        let picker = MPMediaPickerController()
        picker.delegate = self
        picker.allowsPickingMultipleItems = false
        present(picker, animated: true, completion: nil)
        */
    }
    
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
        player = MPMusicPlayerController.systemMusicPlayer()
        
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.runMediaLibraryQuery()
            } else {
                //self.displayMediaLibraryError()
                print("Nope")
            }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Shall be implemented later
    /*
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        player.setQueue(with: mediaItemCollection)
        player.play()
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
    */
    
    func runMediaLibraryQuery() {
        
        // Get all songs from the library
        let mediaItems = MPMediaQuery.songs().items
        // Filter
        var query = MPMediaQuery.songs()
        let predicateByMood = MPMediaPropertyPredicate(value: "Rock", forProperty: MPMediaItemPropertyGenre)
        
        //query.filterPredicates = NSSet(object: predicateByMood)
        
        query.addFilterPredicate(predicateByMood)
        
        let mediaCollection = MPMediaItemCollection(items: query.items!)
        player.setQueue(with: mediaCollection)
        
        /*
        let query = MPMediaQuery.songs()
        if let items = query.items, let item = items.first {
            NSLog("Title: \(item.title)")
        }
        */
    }
}

