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
    // Declaration for player
    var player = MPMusicPlayerController()
    var album = MPMediaItemPropertyAlbumTitle
    var queueCollections = [MPMediaItemCollection]()

    // System declarations
    let notificationCenter = NotificationCenter.default
    let defaults = UserDefaults.standard
    
    // For determining the mood
    var data = Data()
    var currentMoodValue = Data.Mood.undefined.rawValue
    
    
    @IBOutlet weak var currentMood: UILabel!
    @IBOutlet var artist: UILabel!
    @IBOutlet var song: UILabel!
    
    
    let moodPickerValues = [Data.Mood.undefined.rawValue, Data.Mood.happy.rawValue, Data.Mood.sad.rawValue, Data.Mood.melancholic.rawValue, Data.Mood.angry.rawValue]
    
    
    @IBOutlet var artwork: UIImageView!
    @IBOutlet weak var moodPicker: UIPickerView!
    @IBOutlet var playPauseButton: UIButton!
   
    @IBAction func pick(_ sender: AnyObject) {
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
            player.play()
            update()
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
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
        if moodPicker.isHidden == false {
            hideShow(objectA: self.moodPicker, objectB: self.artwork)
        }
        
        if player.playbackState == .playing {
            playPauseButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            update()
            player.pause()
        } else {
            playPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            player.play()
            update()
        }
    }
    
    
    @IBAction func previous(_ sender: AnyObject) {
        // Check if the item in the queue that was set is the first one
        // By the nature of this player, it will drop the last selected songs and find new ones, when pressed next
        if player.currentPlaybackTime < 3.0 && player.nowPlayingItem == queueCollections.last?.items[0] {
            if queueCollections.count > 1 {
                queueCollections.removeLast()
                player.setQueue(with: queueCollections.last!)
                refresh()
            }
        } else {
            player.skipToPreviousItem()
        }
        
        if moodPicker.isHidden == false {
            hideShow(objectA: self.moodPicker, objectB: self.artwork)
        }
    }
    
    @IBAction func next(_ sender: AnyObject) {
        self.runMediaLibraryQuery()
        refresh()
        
        if moodPicker.isHidden == false {
            hideShow(objectA: self.moodPicker, objectB: self.artwork)
        }
    }

    func refresh() {
        if player.playbackState == .playing {
            playPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            player.pause()
            player.play()
            update()
        } else {
            playPauseButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            player.play()
            update()
            player.pause()
        }
    }

    func update() {
        if let cover = player.nowPlayingItem?.artwork?.image(at: artwork.bounds.size) {
            artwork.image = cover
        } else {
            artwork.image = #imageLiteral(resourceName: "songIcon")
        }
        artist.text = player.nowPlayingItem?.albumArtist
        song.text = player.nowPlayingItem?.title
    }
    
    
    func trackFinished(notification: Notification) {
        // If we reach the end of media query, the app runs the media query once again
        // Since the only case it will stop is reaching the end of the query, it created a new one.
        if player.playbackState == .stopped {
            runMediaLibraryQuery()
            player.play()
            update()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moodPicker.dataSource = self
        self.moodPicker.delegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
        moodPicker.isHidden = true
        
        // Loading things for the player
        player = MPMusicPlayerController.systemMusicPlayer()
        
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.runMediaLibraryQuery()
            } else {
                let alert = UIAlertController(title: "Access to songs denied", message: "Please, go to Settings -> MusicMood -> and allow access to Media Library if you want to use the player capabilities of the app", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        // Prevents the Notification from being fired
        player.pause()
        
        // Notify when the player stoped
        player.beginGeneratingPlaybackNotifications()
        notificationCenter.addObserver(self, selector: #selector(self.trackFinished(notification: )), name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: player)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        player.setQueue(with: mediaItemCollection)
        player.play()
    }
    
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
 
    
    func runMediaLibraryQuery() {
        if defaults.bool(forKey: Settings.Setting.UseMuse.rawValue) {
            data.determineMood()
            currentMood.text = Data.CMV.currentMoodValue
            
            // TODO: Implement the proper change of mood in the moodPicker according to the data from the headband
            
            //moodPicker.selectRow(0, inComponent: 0, animated: true)
        }
        
        // Get all songs from the library. Needs to be run in sequence, so asynchronius solution does not work
        let query = MPMediaQuery.songs()
        var queue = [MPMediaItemCollection]()
        
        // Filter the songs for chosen mood by using the comments
        if let collections = query.collections {
            for collection in collections {
                if let representativeTitle = collection.representativeItem!.title, let comment = collection.representativeItem!.comments {
                    //print("Title: \(representativeTitle)  songs: \(collection.items.count) comment: \(comment)")
                    switch Data.CMV.currentMoodValue {
                    case Data.Mood.happy.rawValue:
                        if comment.lowercased().range(of: "#\(Data.Mood.happy.rawValue)") != nil {
                            print("Title: \(representativeTitle) comment: \(comment)")
                            print(Data.Mood.happy.rawValue)
                            queue.append(collection)
                        }
                        
                    case Data.Mood.sad.rawValue:
                        if comment.lowercased().range(of: "#\(Data.Mood.sad.rawValue)") != nil {
                            print("Title: \(representativeTitle) comment: \(comment)")
                            print(Data.Mood.sad.rawValue)
                            queue.append(collection)
                        }
                        
                    case Data.Mood.melancholic.rawValue:
                        if comment.lowercased().range(of: "#\(Data.Mood.melancholic.rawValue)") != nil {
                            print("Title: \(representativeTitle) comment: \(comment)")
                            print(Data.Mood.melancholic.rawValue)
                            queue.append(collection)
                        }
                        
                    case Data.Mood.angry.rawValue:
                        if comment.lowercased().range(of: "#\(Data.Mood.angry.rawValue)") != nil {
                            print("Title: \(representativeTitle) comment: \(comment)")
                            print(Data.Mood.angry.rawValue)
                            queue.append(collection)
                        }
                        
                    case Data.Mood.undefined.rawValue:
                        queue.append(collection)
                        
                    default:
                        print("Bizarre case!")
                        queue.append(collection)
                    }
                }
            }
            
            if queue.count != 0 {
                let randomIndex = Int(arc4random_uniform(UInt32(queue.count)))
                queueCollections.append(queue[randomIndex])
                self.player.setQueue(with: queue[randomIndex])
            } else {
                let alert = UIAlertController(title: "No songs found", message: "There are no songs with \(self.currentMoodValue) mood", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
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
            picking(rowValue: row)
        case 1:
            picking(rowValue: row)
        case 2:
            picking(rowValue: row)
        case 3:
            picking(rowValue: row)
        case 4:
            picking(rowValue: row)
        default:
            currentMood.text = Data.Mood.undefined.rawValue
        }
    }
    
    
    func picking(rowValue: Int) {
        currentMood.text = moodPickerValues[rowValue]
        
        // Setting the mood through the UIPickerView
        currentMoodValue = moodPickerValues[rowValue]
        Data.CMV.currentMoodValue = moodPickerValues[rowValue]
        
        self.runMediaLibraryQuery()
    }
}

