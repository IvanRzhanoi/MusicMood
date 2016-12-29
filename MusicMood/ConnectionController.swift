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
    
    // TODO: Let the app run in the background
    
    
    var muse = IXNMuse()
    var manager = IXNMuseManagerIos()
    var logLines = [Any]()
    var isLastBlink = false
    
    // Declaring an object that will call the functions in SimpleController()
    var connectionController = SimpleController()
    
    var alpha: Double = 0.0
    var beta: Double = 0.0
    var delta: Double = 0.0
    var theta: Double = 0.0
    var gamma: Double = 0.0
    
    
    var alphaSaved = Array(repeating: 0.0, count: 50)
    var betaSaved = Array(repeating: 0.0, count: 50)
    var deltaSaved = Array(repeating: 0.0, count: 50)
    var thetaSaved = Array(repeating: 0.0, count: 50)
    var gammaSaved = Array(repeating: 0.0, count: 50)

    
    var i: Int = 0
    var checkSizeOfCD: Double = 0.0
    let maxData: Int = 50              // Saves only a set amount of values for the brainwave data
    let request: NSFetchRequest<BrainWaveData> = BrainWaveData.fetchRequest()

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
        
        
        
        // TODO: Adapt the code below
        
        

//        let query: NSFetchRequest<BrainWaveData> = BrainWaveData.fetchRequest()
//        do {
//            let fetchResults = try viewContext.fetch(query)
//            for result: AnyObject in fetchResults {
//                let alpha: Double! = result.value(forKey: "alpha") as? Double
//                let beta: Double? = result.value(forKey: "beta") as? Double
//                let delta: Double? = result.value(forKey: "delta") as? Double
//                let theta: Double? = result.value(forKey: "theta") as? Double
//                let gamma: Double? = result.value(forKey: "gamma") as? Double
//                
//                print("CD Alpha: \(alpha)")
//                print("CD Beta: \(beta)")
//                print("CD Delta: \(delta)")
//                print("CD Theta: \(theta)")
//                print("CD Gamma: \(gamma)")
//            }
//        } catch {
//        }

        
        
        
        
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
        //print("\(log.tag): \(log.timestamp) raw: \(log.raw) \(log.message)")
    }
    
    
    // TODO: Investigate the line below. Something wrong with tableView or it's update. It requires the manual table refresh.
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
        //connectionController.tableView(tableView, didSelectRowAt: indexPath)
        print("If this is not called, then it does not do jackshit!")
        var muses = self.manager.getMuses()
        
        if indexPath.row < muses.count {
            print("Everything is fine!")
            // TODO: Add error safety.
            let muse: IXNMuse = muses[indexPath.row] as! IXNMuse
            print("Everything is fine!")
            print("Everything is fine!")
            //var synchronius = DispatchQueue
            //DispatchQueue.main.sync {
            
            print("Everything is fine!")
            
            
            // TODO: Add the proper checking, so it wouldn't be initialized each time
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
            
            // T
            self.muse = muse
            
            print("It should call!\n")
            self.connect()
            print("======Chose device to connect: \(self.muse.getName()) \(self.muse.getMacAddress())======\n")
        }
        //self.connect()
    }
    
    func receive(_ packet: IXNMuseConnectionPacket, muse: IXNMuse?) {       // TODO: Find and error over here!
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
        print("It does call indeed!\n")
        //self.muse.register(self)
        self.muse.register(self)
        self.muse.register(self, type: IXNMuseDataPacketType.artifacts)
        
        self.muse.register(self, type: IXNMuseDataPacketType.alphaAbsolute)
        self.muse.register(self, type: IXNMuseDataPacketType.betaAbsolute)
        self.muse.register(self, type: IXNMuseDataPacketType.deltaAbsolute)
        self.muse.register(self, type: IXNMuseDataPacketType.thetaAbsolute)
        self.muse.register(self, type: IXNMuseDataPacketType.gammaAbsolute)
        
//        self.muse.register(self, type: IXNMuseDataPacketType.eeg)
        
//        self.muse.register(self, type: IXNMuseDataPacketType.alphaRelative)
//        self.muse.register(self, type: IXNMuseDataPacketType.betaRelative)
//        self.muse.register(self, type: IXNMuseDataPacketType.deltaRelative)
//        self.muse.register(self, type: IXNMuseDataPacketType.thetaRelative)
//        self.muse.register(self, type: IXNMuseDataPacketType.gammaRelative)
        
        
        // Clean the Core Data, if it exists
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<BrainWaveData> = BrainWaveData.fetchRequest()
        
        do {
            let fetchResults = try viewContext.fetch(request)
            for result: AnyObject in fetchResults {
                let record = result as! NSManagedObject
                viewContext.delete(record)
            }
            try viewContext.save()
        } catch {
        }

        // Creating Core Data
        for _ in 0...maxData {
            let data = NSEntityDescription.entity(forEntityName: "BrainWaveData", in: viewContext)
            let newRecord = NSManagedObject(entity: data!, insertInto: viewContext)


            newRecord.setValue(0.0, forKey: "alpha") //値を代入
            newRecord.setValue(0.0, forKey: "beta") //値を代入
            newRecord.setValue(0.0, forKey: "delta") //値を代入
            newRecord.setValue(0.0, forKey: "theta") //値を代入
            newRecord.setValue(0.0, forKey: "gamma") //値を代入
            
            do {
                try viewContext.save()
            } catch {
            }
        }

        self.muse.runAsynchronously()
    }
    
    
    func receive(_ packet: IXNMuseDataPacket?, muse: IXNMuse?) {
        
        
        switch packet!.packetType() {
        case IXNMuseDataPacketType.alphaAbsolute:
            if let info = packet?.values() {
                alpha = calculate(info: info as NSArray)
                print("Alpha: \(alpha)")
            }
            
        case IXNMuseDataPacketType.betaAbsolute:
            if let info = packet?.values() {
                beta = calculate(info: info as NSArray)
                print("Beta: \(beta)")
            }
            
        case IXNMuseDataPacketType.deltaAbsolute:
            if let info = packet?.values() {
                delta = calculate(info: info as NSArray)
                print("Delta: \(delta)")
            }
            
        case IXNMuseDataPacketType.thetaAbsolute:
            if let info = packet?.values() {
                theta = calculate(info: info as NSArray)
                print("Theta: \(theta)")
            }
            
        case IXNMuseDataPacketType.gammaAbsolute:
            if let info = packet?.values() {
                //print("\(info[0]) \(info[1]) \(info[2]) \(info[3]) \(info[4]) \(info[5])")
                gamma = calculate(info: info as NSArray)
                print("Gamma: \(gamma)")
                
                alphaSaved[i] = alpha
                betaSaved[i] = beta
                deltaSaved[i] = delta
                thetaSaved[i] = theta
                gammaSaved[i] = gamma
                // Declaring values for CoreData
                // For saving

                
                //let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                //let viewContext = appDelegate.persistentContainer.viewContext

                
//                let data = NSEntityDescription.entity(forEntityName: "BrainWaveData", in: viewContext)
//                let newRecord = NSManagedObject(entity: data!, insertInto: viewContext)
                

//                newRecord.setValue(alpha, forKey: "alpha") //値を代入
//                newRecord.setValue(beta, forKey: "beta") //値を代入
//                newRecord.setValue(delta, forKey: "delta") //値を代入
//                newRecord.setValue(theta, forKey: "theta") //値を代入
//                newRecord.setValue(checkSizeOfCD, forKey: "gamma") //値を代入
//                let request: NSFetchRequest<BrainWaveData> = BrainWaveData.fetchRequest()

                

//                do {
//                    let fetchResults = try viewContext.fetch(request)
//                    fetchResults[i].setValue(alpha, forKey: "alpha")
//                    fetchResults[i].setValue(beta, forKey: "beta")
//                    fetchResults[i].setValue(delta, forKey: "delta")
//                    fetchResults[i].setValue(theta, forKey: "theta")
//                    fetchResults[i].setValue(gamma, forKey: "gamma")
//                    
//                    try viewContext.save()
//                } catch {
//                }
                
                
                
                // For reading
                //let query: NSFetchRequest<BrainWaveData> = BrainWaveData.fetchRequest()
                
                // The lines below limit the scanning, but not the input
                //query.fetchLimit = 500      // for 50 seconds
                
                
                //request.fetchLimit = 500
                
                
                                
                checkSizeOfCD += 1
                i += 1
                print("\(i)")
                
                if i == maxData {
                    do {
                        i = 0
                        for j in 0...maxData-1 {
                            print("CD ________________________________-   Alpha: \(Double(alphaSaved[j]))")
                            print("CD Beta: \(Double(betaSaved[j]))")
                            print("CD Delta: \(Double(deltaSaved[j]))")
                            print("CD Theta: \(Double(thetaSaved[j]))")
                            print("CD Gamma: \(Double(gammaSaved[j]))")
                        }
                        
                        
//                        let fetchResults = try viewContext.fetch(request)
//                        for result: AnyObject in fetchResults {
//                            let alpha: Double! = result.value(forKey: "alpha") as? Double
//                            let beta: Double! = result.value(forKey: "beta") as? Double
//                            let delta: Double! = result.value(forKey: "delta") as? Double
//                            let theta: Double! = result.value(forKey: "theta") as? Double
//                            let gamma: Double! = result.value(forKey: "gamma") as? Double
//                            
//                            print("CD ________________________________-   Alpha: \(Double(alpha))")
//                            print("CD Beta: \(Double(beta))")
//                            print("CD Delta: \(Double(delta))")
//                            print("CD Theta: \(Double(theta))")
//                            print("CD Gamma: \(Double(gamma))")
//                        }
                    } catch {
                    }
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
    
    
//    TODO: Maybe I will delete this function, because it is stupid to just disconnect.
//    func applicationWillResignActive() {
//        print("disconnecting before going into background")
//        //self.muse.disconnect(true)
//    }
    
    
    @IBAction func disconnect(_ sender: AnyObject) {
        
        // TODO: Make a proper disconnect. 
        
//        if self.muse.getConnectionState() == IXNConnectionState.connected {

//        if self.muse != NSObject{
//            self.muse.disconnect(true)
//        }
        
        
        //self.muse.disconnect(true)
    }
    
    @IBAction func scan(_ sender: AnyObject) {
        //SimpleController().scan(AnyObject)
        self.manager.startListening()
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    @IBAction func stopScan(_ sender: AnyObject) {
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
