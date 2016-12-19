//
//  Connect.swift
//  MusicMood
//
//  Created by Ivan Rzhanoi on 27/10/2016.
//  Copyright © 2016 Ivan Rzhanoi. All rights reserved.
//

import UIKit


class Connect: UIViewController, IXNMuseConnectionListener, IXNMuseDataListener, IXNMuseListener, IXNLogListener, UITableViewDelegate, UITableViewDataSource {
    
    var muse = IXNMuse()
    var manager = IXNMuseManagerIos()
    //var logLines = MutableArray
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    

    @IBOutlet weak var tableView: UITableView!
    
    
    func log(fmt: String) {
        //var args: CVaListPointer
        
        // TODO: Insert line
        // TODO: Insert line
        // TODO: Insert line
        // TODO: Insert line
        //print("\(line)")
    }
    
    func receiveLog(_ log: IXNLogPacket) {
        //
    }
    
    func museListChanged() {
        self.tableView.reloadData()
    }
    
    
    
    /*
    - (void)log:(NSString *)fmt, ... {
    va_list args;
    va_start(args, fmt);
    NSString *line = [[NSString alloc] initWithFormat:fmt arguments:args];
    va_end(args);
    NSLog(@"%@", line);
    [self.logLines insertObject:line atIndex:0];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
    [self.logView setText:[self.logLines componentsJoinedByString:@"\n"]];
    });
    }

    */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let simpleTableIdentifier: String = "nil"
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)!
        
        if cell == nil {
            // TODO: Insert the corresponding function
        }
        
        var muses: Array = self.manager.getMuses()
        if indexPath.row < muses.count {
            var muse: IXNMuse = self.manager.getMuses()[indexPath.row] as! IXNMuse
            muse.getMacAddress()
        }
        
        return cell
    }
    
    /*
    - (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"nil";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    simpleTableIdentifier];
    
    if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
    reuseIdentifier:simpleTableIdentifier];
    }
    NSArray * muses = [self.manager getMuses];
    
    if (indexPath.row < [muses count]) {
    IXNMuse * muse = [[self.manager getMuses] objectAtIndex:indexPath.row];
    cell.textLabel.text = [muse getName];
    
    if (![muse isLowEnergy]) {
    cell.textLabel.text = [cell.textLabel.text stringByAppendingString:
    [muse getMacAddress]];
    }
    }
    return cell;
    }
    */
    
    func tableView(tableView: UITableView, indexPath: IndexPath) {
        var muses: Array = self.manager.getMuses()
        if indexPath.row < muses.count {
            
            // TODO: Add error safety.
            let muse: IXNMuse = muses[indexPath.row] as! IXNMuse//muses[indexPath.row]
            
            //var synchronius = DispatchQueue
            DispatchQueue.main.sync {
                if self.muse == nil {
                    self.muse = muse
                } else if self.muse != muse {
                    self.muse.disconnect(false)
                    self.muse = muse
                }
            }
            
            self.connect()
            // TODO: Below implement the proper function
            //  [self log:@"======Choose to connect muse %@ %@======\n", [self.muse getName], [self.muse getMacAddress]];
            print("======Choose device to connect \(self.muse.getName()) \(self.muse.getMacAddress())======\n")
            // Above:
        }
    }
    
    /*
    - (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSArray * muses = [self.manager getMuses];
    if (indexPath.row < [muses count]) {
    
    IXNMuse * muse = [muses objectAtIndex:indexPath.row];
    
    @synchronized (self.muse) {
    if(self.muse == nil) {
    self.muse = muse;
    }else if(self.muse != muse) {
    [self.muse disconnect:false];
    self.muse = muse;
    }
    }
    [self connect];
    [self log:@"======Choose to connect muse %@ %@======\n",
    [self.muse getName], [self.muse getMacAddress]];
    }
    }
    
    */
    
    func receive(_ packet: IXNMuseDataPacket?, muse: IXNMuse?) {
        //
    }
    
    func receive(_ packet: IXNMuseConnectionPacket, muse: IXNMuse?) {
        //
    }
    
    
    func connect() {
        //self.muse.register(self)
        self.muse.register(self)
        self.muse.register(self, type: IXNMuseDataPacketType.artifacts)
        self.muse.register(self, type: IXNMuseDataPacketType.alphaAbsolute)
        
        //self.muse.register(self, type: IXNMuseDataPacketType.eeg)
        
        self.muse.runAsynchronously()
    }
    
    func receiveMuseDataPacket(packet: IXNMuseDataPacket, muse: IXNMuse) {
        if packet.packetType() == IXNMuseDataPacketType.alphaAbsolute || packet.packetType() == IXNMuseDataPacketType.eeg {
            print("Alpha: \(IXNEeg.EEG1.rawValue) Beta: \(IXNEeg.EEG2) Gamma: \(IXNEeg.EEG3) Theta: \(IXNEeg.EEG4)", packet.values())
            print("%5.2f %5.2f %5.2f %5.2f", packet.values())
        }
    }
    
    func receive(_ packet: IXNMuseArtifactPacket, muse: IXNMuse?) {
        //
    }
    
    func applicationWillResignActive() {
    
    }
    
    
    @IBAction func disconnect(_ sender: AnyObject) {
            //muse.disconnect(true)
    }
    
    @IBAction func scan(_ sender: AnyObject) {
        self.manager.startListening()
        self.tableView.reloadData()
    }
    
    @IBAction func stopScan(_ sender: AnyObject) {
        self.manager.stopListening()
        self.tableView.reloadData()
    }
    
    /*
    - (IBAction)disconnect:(id)sender {
    if (self.muse) [self.muse disconnect:true];
    }
    
    - (IBAction)scan:(id)sender {
    [self.manager startListening];
    [self.tableView reloadData];
    }
    
    - (IBAction)stopScan:(id)sender {
    [self.manager stopListening];
    [self.tableView reloadData];
    }
*/
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
