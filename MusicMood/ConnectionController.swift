//
//  ConnectionController.swift
//  MuseStatIos_Swift
//
//  Created by Ivan Rzhanoi on 24/11/2016.
//  Copyright © 2016 Ivan Rzhanoi. All rights reserved.
//

import UIKit
import CoreData

class ConnectionController: UIViewController, IXNMuseConnectionListener, IXNMuseDataListener, IXNMuseListener, IXNLogListener, UITableViewDelegate, UITableViewDataSource {
    
    // Threads
    var tableRefresherWorks: Bool = true
    
    // Variables for MUSE headband
    var muse = IXNMuse()
    var manager = IXNMuseManagerIos()
    var logLines = [Any]()
    var isLastBlink = false
    // It is impossible now to check the connection of the headband, so the flag is created here
    var isConnected = false
    
    // Declaring an object that will call the functions in SimpleController()
    var connectionController = SimpleController()
    
    var data = Data()
    
    // Variable below is used to store data in the array in the cycle
    var i: Int = 0
    
    

    @IBOutlet var tableView: UITableView!
    
    
    @IBOutlet var alphaCurrent: UILabel!
    @IBOutlet var betaCurrent: UILabel!
    @IBOutlet var deltaCurrent: UILabel!
    @IBOutlet var thetaCurrent: UILabel!
    @IBOutlet var gammaCurrent: UILabel!
    
    @IBOutlet var alphaAverage: UILabel!
    @IBOutlet var betaAverage: UILabel!
    @IBOutlet var deltaAverage: UILabel!
    @IBOutlet var thetaAverage: UILabel!
    @IBOutlet var gammaAverage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.manager = IXNMuseManagerIos.sharedManager()
        
        //updateAverageBrainWave()
    }
    
        override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
            self.manager = IXNMuseManagerIos.sharedManager()
            self.manager.museListener = self
            self.tableView = UITableView()
            self.logLines = [Any]()
            
            IXNLogManager.instance()?.setLogListener(self)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            
            let dateStr = dateFormatter.string(from: Date()).appending(".log")
            print("\(dateStr)")
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
    
    func receiveLog(_ log: IXNLogPacket) {
        connectionController.receiveLog(log)
    }
    
    
    func museListChanged() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = connectionController.tableView(tableView, numberOfRowsInSection: section)
        return rows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = connectionController.tableView(tableView, cellForRowAt: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The function below works fine. However, I decided to recreate it in Swift 3 for greater flexibility and further porting
        // ---> connectionController.tableView(tableView, didSelectRowAt: indexPath)
        
        
        var muses = self.manager.getMuses()
        
        if indexPath.row < muses.count {
            let muse: IXNMuse = muses[indexPath.row] as! IXNMuse

            self.tableRefresherWorks = false
            self.muse = muse
            self.connect()
            //print("======Chose device to connect: \(self.muse.getName()) \(self.muse.getMacAddress())======\n")
        }
    }
    
    
    func receive(_ packet: IXNMuseConnectionPacket, muse: IXNMuse?) {
        var state: String
        switch packet.currentConnectionState {
        case IXNConnectionState.disconnected:
            state = "disconnected"
        case IXNConnectionState.connected:
            state = "connected"
        case IXNConnectionState.connecting:
            state = "connecting"
        case IXNConnectionState.needsUpdate:
            state = "needs update"
        case IXNConnectionState.unknown:
            state = "unknown"
        }
        print("connect: \(state)")
    }
    
    
    func connect() {
        self.muse.register(self)
        self.muse.register(self, type: IXNMuseDataPacketType.artifacts)
        
        self.muse.register(self, type: IXNMuseDataPacketType.alphaAbsolute)
        self.muse.register(self, type: IXNMuseDataPacketType.betaAbsolute)
        self.muse.register(self, type: IXNMuseDataPacketType.deltaAbsolute)
        self.muse.register(self, type: IXNMuseDataPacketType.thetaAbsolute)
        self.muse.register(self, type: IXNMuseDataPacketType.gammaAbsolute)
        
        self.muse.runAsynchronously()
        
        isConnected = true
    }
    
    
    func receive(_ packet: IXNMuseDataPacket?, muse: IXNMuse?) {
        switch packet!.packetType() {
        case IXNMuseDataPacketType.alphaAbsolute:
            if let info = packet?.values() {
                Data.Waves["alpha"]?[i] = calculate(info: info as NSArray)
                alphaCurrent.text = String(format: "%.5f", Double((Data.Waves["alpha"]?[i])!))
            }
            
        case IXNMuseDataPacketType.betaAbsolute:
            if let info = packet?.values() {
                Data.Waves["beta"]?[i] = calculate(info: info as NSArray)
                betaCurrent.text = String(format: "%.5f", Double((Data.Waves["beta"]?[i])!))
            }
            
        case IXNMuseDataPacketType.deltaAbsolute:
            if let info = packet?.values() {
                Data.Waves["delta"]?[i] = calculate(info: info as NSArray)
                deltaCurrent.text = String(format: "%.5f", Double((Data.Waves["delta"]?[i])!))
            }
            
        case IXNMuseDataPacketType.thetaAbsolute:
            if let info = packet?.values() {
                Data.Waves["theta"]?[i] = calculate(info: info as NSArray)
                thetaCurrent.text = String(format: "%.5f", Double((Data.Waves["theta"]?[i])!))
            }
            
        case IXNMuseDataPacketType.gammaAbsolute:
            if let info = packet?.values() {
                Data.Waves["gamma"]?[i] = calculate(info: info as NSArray)
                gammaCurrent.text = String(format: "%.5f", Double((Data.Waves["gamma"]?[i])!))
                
                //print("Gamma: \(Double((Data.Waves["gamma"]?[i])!))")
                //print("\(info[0]) \(info[1]) \(info[2]) \(info[3]) \(info[4]) \(info[5])")
              
                
                i += 1
                // if-statement below keeps the rotation through the dictionary values
                // This logic works, because MUSE Headband saves brainwave data sequentially
                if i == data.dataSize {
                    i = 0
                }
            }
            
        default:
            print("another package")
        }
    }
    
    
    func calculate(info: NSArray) -> Double {
        var value: Double = 0.0
        var divisor: Double = 0.0
        for i in 0...5 {
            
            // TODO: Find a more elegant solution to the problem
            // Check, because gamma sends 2 nan (Not a Number) in a package
            if (info[i] as! Double).isNaN == false {
                value += (info[i] as! Double)
                divisor += 1                            // we divide only for given information
            }
//            else {
//                print("\(info[i])")
//            }
        }
        value = value / divisor
        
        return value
    }
    
    func updateAverageBrainWave() {
        alphaAverage.text = String(format: "%.5f", Double(Data.WavesAverage["alpha"]!))
        betaAverage.text = String(format: "%.5f", Double(Data.WavesAverage["beta"]!))
        deltaAverage.text = String(format: "%.5f", Double(Data.WavesAverage["delta"]!))
        gammaAverage.text = String(format: "%.5f", Double(Data.WavesAverage["gamma"]!))
        thetaAverage.text = String(format: "%.5f", Double(Data.WavesAverage["theta"]!))
    }
    
    
    func receive(_ packet: IXNMuseArtifactPacket, muse: IXNMuse?) {
        if packet.blink && packet.blink != self.isLastBlink {
            //print("Blink detected")
        }
        self.isLastBlink = packet.blink
    }
    
    
    
    
    @IBAction func disconnect(_ sender: AnyObject) {
        // This solution is not very good as it relies on the flag and not an actual status check
        // But unfortunately that is the only way right now as the check function does not transition to swift 3 from Objective-C
        if isConnected {
            self.muse.disconnect(true)
            isConnected = false
        }
    }
    
    
    @IBAction func scan(_ sender: AnyObject) {
        var checkingTime: Int = 0
        self.tableRefresherWorks = true
        
        self.manager.startListening()
        
        DispatchQueue.global(qos: .background).async {
            while checkingTime < 300 && self.tableRefresherWorks {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                checkingTime += 1
                Thread.sleep(forTimeInterval: 1.0)
            }
        }
    }
    
    @IBAction func stopScan(_ sender: AnyObject) {
        self.tableRefresherWorks = false
        self.manager.stopListening()
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
