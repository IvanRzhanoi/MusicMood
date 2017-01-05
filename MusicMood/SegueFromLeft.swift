//
//  SegueFromLeft.swift
//  MusicMood
//
//  Created by Ivan Rzhanoi on 05/01/2017.
//  Copyright © 2017 Ivan Rzhanoi. All rights reserved.
//

import UIKit

class SegueFromLeft: UIStoryboardSegue {
//    override func perform() {
//        let src: UIViewController = self.source
//        let dst: UIViewController = self.destination
//        let transition: CATransition = CATransition()
//        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.duration = 0.25
//        transition.timingFunction = timeFunc
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromLeft
//        src.navigationController!.view.layer.add(transition, forKey: kCATransition)
//        src.navigationController!.pushViewController(dst, animated: false)
//    }
    
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: {
            finished in src.present(dst, animated: false, completion: nil)
        })
    }
}
