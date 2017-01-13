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
        case undefined
        case happy
        case sad
        case melancholic
        case angry
    }
    
    
    var currentMoodValue = Mood.undefined.rawValue
    
    
    @IBOutlet weak var currentMood: UILabel!
    @IBOutlet var artist: UILabel!
    @IBOutlet var song: UILabel!
    
        
    
    // Player part
    let moodPickerValues = [Mood.undefined.rawValue, Mood.happy.rawValue, Mood.sad.rawValue, Mood.melancholic.rawValue, Mood.angry.rawValue]
    
    
    @IBOutlet var artwork: UIImageView!
    @IBOutlet weak var moodPicker: UIPickerView!
    @IBOutlet var playPauseButton: UIButton!
   
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
        player.skipToPreviousItem()
        if moodPicker.isHidden == false {
            hideShow(objectA: self.moodPicker, objectB: self.artwork)
        }
    }
    
    @IBAction func next(_ sender: AnyObject) {
        // For now for testing it is pausing
//        for i in 0...data.dataSize-1 {
//            //print("\(Data.Waves.alpha[i])")
//            print("Alpha stored: \(Double((Data.Waves["alpha"]?[i])!))")
//        }
//        data.determineMood()
        
   
        self.runMediaLibraryQuery()
        if player.playbackState == .playing {
            playPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            player.stop()
            player.play()
            update()
        } else {
            playPauseButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            player.play()
            update()
            player.pause()
        }
   
        if moodPicker.isHidden == false {
            hideShow(objectA: self.moodPicker, objectB: self.artwork)
        }
    }


    func update() {
        artwork.image = player.nowPlayingItem?.artwork?.image(at: artwork.bounds.size)
        artist.text = player.nowPlayingItem?.albumArtist
        song.text = player.nowPlayingItem?.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moodPicker.dataSource = self
        self.moodPicker.delegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Loading things for the player
        //moodPicker.selectRow(3, inComponent: 0, animated: true)
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
        self.runMediaLibraryQuery()
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
        //let mediaItems = MPMediaQuery.songs().items
        
        
        // Filter
        //let query = MPMediaQuery.songs()
        
        
        //let query = MPMediaQuery.albums()
        let query = MPMediaQuery.songs()
        var queue = [MPMediaItemCollection]()
        
        
        // Trying to filter the songs out by comments
        
        // 「アルバム」単位で取得
        
        // TODO: Update the display, because instead of albums I now have songs
        // 取得したアルバム情報を表示
        if let collections = query.collections {
            for collection in collections {
                if let representativeTitle = collection.representativeItem!.title, let comment = collection.representativeItem!.comments {
                    //print("Title: \(representativeTitle)  songs: \(collection.items.count) comment: \(comment)")
                    
                    
                    // TODO: Implement the switch statement
                    switch currentMoodValue {
                    case Mood.happy.rawValue:
                        if comment.lowercased().range(of: "#\(Mood.happy.rawValue)") != nil {
                            print("Title: \(representativeTitle) comment: \(comment)")
                            print(Mood.happy.rawValue)
                            queue.append(collection)
                        }
                    case Mood.sad.rawValue:
                        if comment.lowercased().range(of: "#\(Mood.sad.rawValue)") != nil {
                            print("Title: \(representativeTitle) comment: \(comment)")
                            print(Mood.sad.rawValue)
                            queue.append(collection)
                        }
                    case Mood.melancholic.rawValue:
                        if comment.lowercased().range(of: "#\(Mood.melancholic.rawValue)") != nil {
                            print("Title: \(representativeTitle) comment: \(comment)")
                            print(Mood.melancholic.rawValue)
                            queue.append(collection)
                        }
                    case Mood.angry.rawValue:
                        if comment.lowercased().range(of: "#\(Mood.angry.rawValue)") != nil {
                            print("Title: \(representativeTitle) comment: \(comment)")
                            print(Mood.angry.rawValue)
                            queue.append(collection)
                        }
                    case Mood.undefined.rawValue:
                        queue.append(collection)
                    default:
                        print("Bizarre case!")
                        queue.append(collection)
                    }
                }
            }
        }
        
        
        if queue.count != 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(queue.count)))
            player.setQueue(with: queue[randomIndex])
        } else {
            let alert = UIAlertController(title: "No songs found", message: "There are no songs with \(currentMoodValue) mood", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
            currentMood.text = Mood.undefined.rawValue
        }
    }
    
    func picking(rowValue: Int) {
        currentMood.text = moodPickerValues[rowValue]
        currentMoodValue = moodPickerValues[rowValue]
        self.runMediaLibraryQuery()
    }
}

