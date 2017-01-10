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
    
    var data = Data()
    
    enum Mood: String {
        case happy
        case sad
        case melancholic
        case undefined
    }
    
    
    var currentMoodValue = Mood.undefined.rawValue
    
    
    @IBOutlet weak var currentMood: UILabel!
    
    
    
    
    
    
    
    
    
    
    // Player part
    let moodPickerValues = [Mood.happy.rawValue, Mood.sad.rawValue, Mood.melancholic.rawValue]
    
    
    @IBOutlet var artwork: UIImageView!
    @IBOutlet weak var moodPicker: UIPickerView!
    
    @IBAction func pick(_ sender: AnyObject) {
        // Useless for now
        
        let picker = MPMediaPickerController()
        picker.delegate = self
        picker.allowsPickingMultipleItems = false
        present(picker, animated: true, completion: nil)
 
    }
    
    @IBAction func mood(_ sender: AnyObject) {
        if moodPicker.isHidden {
            hideShow(objectA: self.artwork, objectB: self.moodPicker)
        } else {
            hideShow(objectA: self.moodPicker, objectB: self.artwork)
        }
    }
    
    // Hide current object, show the desired one
    func hideShow(objectA: UIView, objectB: UIView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            objectA.alpha = 0               // Animation
        }, completion: { finished in
            objectA.isHidden = true         // Hiding
        })
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            objectB.alpha = 1
        }, completion: { finished in
            objectB.isHidden = false
        })
    }
    
    @IBAction func playPause(_ sender: AnyObject) {
        moodPicker.isHidden = true
        
        /*if player.playbackState != 1.0 {
            currentMood.text = "rarar"
            player.play()
        }
        else {
            // Playing, so pause.
            currentMood.text = "Static"
            player.pause()
        }*/
        
        
        
        
        self.runMediaLibraryQuery()
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
        //player.skipToNextItem()
        for i in 0...data.dataSize-1 {
            //print("\(Data.Waves.alpha[i])")
            print("Alpha stored: \(Double((Data.Waves["alpha"]?[i])!))")
        }
        data.determineMood()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moodPicker.dataSource = self
        self.moodPicker.delegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //manager = IXNMuseManagerIos.sharedManager()
        
        
        
        
        
        // Loading things for the player
        moodPicker.isHidden = true
        
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
        return moodPickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return moodPickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            currentMood.text = moodPickerValues[row]
            currentMoodValue = moodPickerValues[row]
        case 1:
            currentMood.text = moodPickerValues[row]
            currentMoodValue = moodPickerValues[row]
        case 2:
            currentMood.text = moodPickerValues[row]
            currentMoodValue = moodPickerValues[row]
        default:
            currentMood.text = "#static"
        }
    }

}

