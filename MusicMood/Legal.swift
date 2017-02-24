//
//  Legal.swift
//  MusicMood
//
//  Created by Ivan Rzhanoi on 24/02/2017.
//  Copyright © 2017 Ivan Rzhanoi. All rights reserved.
//

import UIKit

class Legal: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        transition.subtype = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
}
