//
//  Settings.swift
//  MusicMood
//
//  Created by Ivan Rzhanoi on 05/01/2017.
//  Copyright © 2017 Ivan Rzhanoi. All rights reserved.
//

import UIKit

class Settings: UIViewController {
    let defaults = UserDefaults.standard
    
    enum Setting: String {
        case UseMuse
        case SaveMood
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   
        // Setting up switches, depending on the setting
        let umSwitch = defaults.bool(forKey: Setting.UseMuse.rawValue)
        useMuseOutlet.setOn(umSwitch, animated: false)
        saveMood.setOn(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet var useMuseOutlet: UISwitch!
    @IBAction func useMuseSetting(_ sender: Any) {
        if useMuseOutlet.isOn {
            defaults.set(true, forKey: Setting.UseMuse.rawValue)
        } else {
            defaults.set(false, forKey: Setting.UseMuse.rawValue)
        }
    }
    
    @IBOutlet var saveMood: UISwitch!
    @IBAction func saveMoodSetting(_ sender: Any) {
    }
    
    
    @IBAction func dismiss(_ sender: AnyObject) {
// Alternative animation
//        let tmpController :UIViewController! = self.presentingViewController;
//
//        self.dismiss(animated: false, completion: {()->Void in
//            print("done");
//            tmpController.dismiss(animated: true, completion: nil);
//        });
        
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
}
