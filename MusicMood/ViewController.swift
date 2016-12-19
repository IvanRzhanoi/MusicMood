//
//  ViewController.swift
//  MusicMood
//
//  Created by Ivan Rzhanoi on 22/09/2016.
//  Copyright © 2016 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MPMediaPickerControllerDelegate {
    
    // Declaration for Muse
    //var manager = IXNMuseManagerIos();
    //var muse = IXNMuse();
    //let MuseController = SimpleController()
    
    // Declaration for player
    //let player = AVPlayer()
    var player = MPMusicPlayerController()
    var album = MPMediaItemPropertyAlbumTitle
    //var mood = MPMediaItemPropertyUserGrouping
    //var mood = MPMediaItemPropertyComments
    
    
    enum Mood: String {
        case happy
        case sad
        case melancholic
    }
    
    
    var currentMoodValue = "Rock"
    
    
    @IBOutlet weak var currentMood: UILabel!
    
    
    // MUSE Connectivity

    @IBOutlet weak var alphaCurrent: UILabel!

    
    
    
    
    
    
    
    
    
    
    // Player part
    let genrePickerValues = [Mood.happy.rawValue, Mood.sad.rawValue, Mood.melancholic.rawValue]
    @IBOutlet weak var genrePicker: UIPickerView!
    @IBAction func pick(_ sender: AnyObject) {
        // Useless for now
        
        let picker = MPMediaPickerController()
        picker.delegate = self
        picker.allowsPickingMultipleItems = false
        present(picker, animated: true, completion: nil)
 
    }
    
    @IBAction func genre(_ sender: AnyObject) {
        genrePicker.isHidden = false
    }
    
    
    
    @IBAction func playPause(_ sender: AnyObject) {
        genrePicker.isHidden = true
        
        /*if player.playbackState != 1.0 {
            currentMood.text = "rarar"
            player.play()
        }
        else {
            // Playing, so pause.
            currentMood.text = "Static"
            player.pause()
        }*/
        
        
        
        
        runMediaLibraryQuery()
        player.play()
        
        
        
        /*
        if (player.nowPlayingItem != nil) {
            player.pause()
        } else {
            player.play()
        }
        */
    }
    @IBAction func previous(_ sender: AnyObject) {
        player.skipToPreviousItem()
    }
    
    @IBAction func next(_ sender: AnyObject) {
        // For now for testing it is pausing
        player.skipToNextItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.genrePicker.dataSource = self
        self.genrePicker.delegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //manager = IXNMuseManagerIos.sharedManager()
        
        
        
        
        
        // Loading things for the player
        genrePicker.isHidden = true
        
        player = MPMusicPlayerController.systemMusicPlayer()
        
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.runMediaLibraryQuery()
            } else {
                //self.displayMediaLibraryError()
                print("Nope")
            }
        }
        //MuseController.receive(IXNMuseConnectionPacket, muse: IXNMuse)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // Functions for the media player
    
    
    // Shall be implemented later
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        player.setQueue(with: mediaItemCollection)
        player.play()
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
 
    
    func runMediaLibraryQuery() {
        
        // Get all songs from the library
        let mediaItems = MPMediaQuery.songs().items
        
        
        // Filter
        //let query = MPMediaQuery.songs()
        
        
        let query = MPMediaQuery.albums()
        
        
        
        let predicateByMood = MPMediaPropertyPredicate(value: currentMoodValue, forProperty: MPMediaItemPropertyGenre)
        
        
        
        let predicateByComment = MPMediaPropertyPredicate(value: currentMoodValue, forProperty: MPMediaItemPropertyGenre)
        
        //query.filterPredicates = NSSet(object: predicateByMood)
        
        //query.filterPredicates(predicateByMood)
        //query.addFilterPredicate(predicateByMood)
        //query.addFilterPredicate(predicateByComment)
        
        let mediaCollection = MPMediaItemCollection(items: query.items!)
        player.setQueue(with: mediaCollection)
        
        // Trying to filter the songs out by comments
        
        // 「アルバム」単位で取得
        
        
        // 取得したアルバム情報を表示
        if let collections = query.collections {
            for collection in collections {
                if let representativeTitle = collection.representativeItem!.albumTitle, let comment = collection.representativeItem!.comments {
                    //print("Title: \(representativeTitle)  songs: \(collection.items.count) comment: \(comment)")
                    
                    
                    // TODO: Implement the switch statement
                    switch currentMoodValue {
                    case Mood.happy.rawValue:
                        if comment.lowercased().range(of: "#\(Mood.happy.rawValue)") != nil {
                            print("Title: \(representativeTitle)  songs: \(collection.items.count) comment: \(comment)")
                            print(Mood.happy.rawValue)
                        }
                    case Mood.sad.rawValue:
                        if comment.lowercased().range(of: "#\(Mood.sad.rawValue)") != nil {
                            print("Title: \(representativeTitle)  songs: \(collection.items.count) comment: \(comment)")
                            print(Mood.sad.rawValue)
                        }
                    case Mood.melancholic.rawValue:
                        if comment.lowercased().range(of: "#\(Mood.melancholic.rawValue)") != nil {
                            print("Title: \(representativeTitle)  songs: \(collection.items.count) comment: \(comment)")
                            print(Mood.melancholic.rawValue)
                        }
                    default:
                        print("static")
                    }
                    
                }
            }
        }
        
        
        
        
        
        
        
        
        
        /*
        let query = MPMediaQuery.songs()
        if let items = query.items, let item = items.first {
            NSLog("Title: \(item.title)")
        }
        */
    }
    
    // UIPickerView
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genrePickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genrePickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            currentMood.text = genrePickerValues[row]
            currentMoodValue = genrePickerValues[row]
        case 1:
            currentMood.text = genrePickerValues[row]
            currentMoodValue = genrePickerValues[row]
        case 2:
            currentMood.text = genrePickerValues[row]
            currentMoodValue = genrePickerValues[row]
        default:
            currentMood.text = "#static"
        }
    }

}

