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
    var manager = IXNMuseManagerIos();
    var muse = IXNMuse();
    //let MuseController = SimpleController()
    
    // Declaration for player
    //let player = AVPlayer()
    var player = MPMusicPlayerController()
    var album = MPMediaItemPropertyAlbumTitle
    //var mood = MPMediaItemPropertyUserGrouping
    var mood = MPMediaItemPropertyComments
    var currentMoodValue = "Rock"
    
    
    @IBOutlet weak var currentMood: UILabel!
    
    
    // MUSE Connectivity

    @IBOutlet weak var alphaCurrent: UILabel!

    
    
    
    
    
    
    
    
    
    
    // Player part
    let genrePickerValues = ["Rock", "Pop", "Jazz"]
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
        manager = IXNMuseManagerIos.sharedManager()
        
        
        
        
        
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

    
    // Functions for Muse connectivity
    
    func receiveMuseConnectionPacket(packet: IXNMuseConnectionPacket, muse: IXNMuse) {
        var state: String
        switch packet.currentConnectionState {
        case IXNConnectionState.disconnected:
            state = "disconnected"
            break
        case IXNConnectionState.connected:
            state = "connected"
            break
        case IXNConnectionState.connecting:
            state = "connecting"
            break
        case IXNConnectionState.needsUpdate:
            state = "needs update"
            break
        case IXNConnectionState.unknown:
            state = "unknown"
            break
        default:
            fatalError("impossible connection state received")
        }
        print(state)
    }
    
    
    
    
    func connect() {
        //self.muse.register(self)
        //self.muse.register(self, type: IXNMuseDataPacketType.artifacts)
        //self.muse.register(self, type: IXNMuseDataPacketType.alphaAbsolute)
        self.muse.runAsynchronously()
    }
    
    /*
    - (void) connect {
    [self.muse registerConnectionListener:self];
    [self.muse registerDataListener:self
    type:IXNMuseDataPacketTypeArtifacts];
    [self.muse registerDataListener:self
    type:IXNMuseDataPacketTypeAlphaAbsolute];
    /*
     [self.muse registerDataListener:self
     type:IXNMuseDataPacketTypeEeg];
     */
    [self.muse runAsynchronously];
    }
    */
    
    
    
    
    
    
    
    func receiveMuseDataPacket(packet: IXNMuseDataPacket, muse: IXNMuse) {
        if packet.packetType() == IXNMuseDataPacketType.alphaAbsolute || packet.packetType() == IXNMuseDataPacketType.eeg {
            print("Alpha: \(IXNEeg.EEG1.rawValue) Beta: \(IXNEeg.EEG2) Gamma: \(IXNEeg.EEG3) Theta: \(IXNEeg.EEG4)", packet.values())
            print("%5.2f %5.2f %5.2f %5.2f", packet.values())
        }
    }
    
    
    /*
    - (void)receiveMuseDataPacket:(IXNMuseDataPacket *)packet
    muse:(IXNMuse *)muse {
    if (packet.packetType == IXNMuseDataPacketTypeAlphaAbsolute ||
    packet.packetType == IXNMuseDataPacketTypeEeg) {
    [self log:@"%5.2f %5.2f %5.2f %5.2f",
    [packet.values[IXNEegEEG1] doubleValue],
    [packet.values[IXNEegEEG2] doubleValue],
    [packet.values[IXNEegEEG3] doubleValue],
    [packet.values[IXNEegEEG4] doubleValue]];
    }
    }
    */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
        var query = MPMediaQuery.songs()
        let predicateByMood = MPMediaPropertyPredicate(value: currentMoodValue, forProperty: MPMediaItemPropertyGenre)
        
        //query.filterPredicates = NSSet(object: predicateByMood)
        
        //query.filterPredicates(predicateByMood)
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
    
    // UIPickerView
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genrePickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
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
            currentMood.text = "Static"
        }
    }

}

