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
    /**
     * Handler method for Muse data packets
     *
     * \warning It is important that you do not perform any computation
     * intensive tasks in this callback. This would result in significant
     * delays in all the listener callbacks from being called. You should
     * delegate any intensive tasks to another thread or schedule it to run
     * with a delay through handler/scheduler for the platform.
     *
     * However, you can register/unregister listeners in this callback.
     * All previously registered listeners would still receive callbacks
     * for this current event. On subsequent events, the newly registered
     * listeners will be called. For example, if you had 2 listeners 'A' and 'B'
     * for this event. If, on the callback for listener A, listener A unregisters
     * all listeners and registers a new listener 'C' and then in the callback for
     * listener 'B', you unregister all listeners again and register a new listener
     * 'D'. Then on the subsequent event callback, only listener D's callback
     * will be invoked.
     *
     * \param packet The data packet
     * \param muse   The
     * \if ANDROID_ONLY
     * Muse
     * \elseif IOS_ONLY
     * IXNMuse
     * \endif
     * that sent the data packet.
     */
    
    
    
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
    var i: Int = 0
    
    

    @IBOutlet var tableView: UITableView!
    @IBOutlet var logView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.delegate = SimpleController()
        
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        
        //if self.manager != nil {
        
        self.manager = IXNMuseManagerIos.sharedManager()
        
        //}

    }
    
        override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
            //if (self == super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)) {
    
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
            self.manager = IXNMuseManagerIos.sharedManager()
            self.manager.museListener = self
            self.tableView = UITableView()
            self.logView = UITextView()
            self.logLines = [Any]()
            self.logView.text = ""
            IXNLogManager.instance()?.setLogListener(self)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            //var dateStr = dateFormatter.string(fromDate: Date()).appending(".log")
            let dateStr = dateFormatter.string(from: Date()).appending(".log")
            print("\(dateStr)")
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
    
    
    
    
    
    func log(fmt: String) {
        // TODO: Since I don't have a log function, maybe just get rid of all the functions.
        
        //log(fmt: fmt)
        //self.log(fmt: fmt)
        
        
        
//        var args: CVaListPointer
//        
//        va_start(args, fmt)
//        
//        var line = String(format: fmt, arguments: [args])
//        
//        va_end(args)
//        
//        print("\(line)")
//        self.logLines.insert(line, at: 0)
        
//        DispatchQueue.main.async(execute: {() -> Void in
//            self.logView.text = (self.logLines as NSArray).componentsJoined(by: "\n")
//        })
        //print("\(line)")
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
        
        
        // The code below works fine. It is simplier to use only one line above, but in case someone would like to completely port it to swift, I kept it.
        
//        let simpleTableIdentifier: String = "nil"
//        let muses = self.manager.getMuses()
//        
//        // Checking for the value. If cell doesn't receive any data (finding nil, while unwraping), we give empty.
//        if let cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier) {
//            
//            if indexPath.row < muses.count {
//                let muse: IXNMuse = self.manager.getMuses()[indexPath.row] as! IXNMuse
//                cell.textLabel!.text = muse.getName()
//                if !muse.isLowEnergy() {
//                    cell.textLabel!.text = cell.textLabel!.text?.appending(muse.getMacAddress())
//                }
//            }
//            return cell
//            
//        } else {
//            let cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
//
//            if indexPath.row < muses.count {
//                let muse: IXNMuse = self.manager.getMuses()[indexPath.row] as! IXNMuse
//                
//                // TODO: Check the code below in the future
//                cell.textLabel?.text = muse.getName()
//                if !muse.isLowEnergy() {
//                    cell.textLabel?.text = cell.textLabel?.text?.appending(muse.getMacAddress())
//                }
//            }
//            return cell
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The function below, which is commented out, works fine
        // ---> connectionController.tableView(tableView, didSelectRowAt: indexPath)
        // However, I decided to recreate it in Swift 3 for greater flexibility
        
        var muses = self.manager.getMuses()
        
        if indexPath.row < muses.count {
            print("Everything is fine!")
            // TODO: Add error safety.
            let muse: IXNMuse = muses[indexPath.row] as! IXNMuse
            print("Everything is fine!")
   
            
            
            //if self.muse.getConfiguration() == nil {
            
            
//            if self.muse == nil {
//                print("Everything is fine!")
//                self.muse = muse
//                print("Everything is  STILL fine!")
//
//            } else if self.muse != muse {
//                // TODO: Add the proper support for disconnecting
//                //self.muse.disconnect(false)
//                self.muse = muse
//            }
            //}
            self.tableRefresherWorks = false

            self.muse = muse
            self.connect()
            print("======Chose device to connect: \(self.muse.getName()) \(self.muse.getMacAddress())======\n")
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
                print("Alpha: \(Double((Data.Waves["alpha"]?[i])!))")
            }
            
        case IXNMuseDataPacketType.betaAbsolute:
            if let info = packet?.values() {
                Data.Waves["beta"]?[i] = calculate(info: info as NSArray)
                print("Beta: \(Double((Data.Waves["beta"]?[i])!))")
            }
            
        case IXNMuseDataPacketType.deltaAbsolute:
            if let info = packet?.values() {
                Data.Waves["delta"]?[i] = calculate(info: info as NSArray)
                print("Delta: \(Double((Data.Waves["delta"]?[i])!))")
            }
            
        case IXNMuseDataPacketType.thetaAbsolute:
            if let info = packet?.values() {
                Data.Waves["theta"]?[i] = calculate(info: info as NSArray)
                print("Theta: \(Double((Data.Waves["theta"]?[i])!))")
            }
            
        case IXNMuseDataPacketType.gammaAbsolute:
            if let info = packet?.values() {
                //print("\(info[0]) \(info[1]) \(info[2]) \(info[3]) \(info[4]) \(info[5])")
                Data.Waves["gamma"]?[i] = calculate(info: info as NSArray)
                print("Gamma: \(Double((Data.Waves["gamma"]?[i])!))")
                
              
                
                i += 1
                
                // if-statement below keeps the rotation through the dictionary values
                if i == data.dataSize {
                    // TODO: Move this function to the main controller
                    data.determineMood()
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
            if (info[i] as! Double).isNaN == false {  // &&  != 0.0 {
                value += (info[i] as! Double)
                divisor += 1                            // we divide only for given information
            }
        }
        value = value / divisor
        
        return value
    }
    
    func receive(_ packet: IXNMuseArtifactPacket, muse: IXNMuse?) {
        if packet.blink && packet.blink != self.isLastBlink {
            self.log(fmt: "blink detected")
        }
        self.isLastBlink = packet.blink
    }
    

    
    @IBAction func disconnect(_ sender: AnyObject) {
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

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
