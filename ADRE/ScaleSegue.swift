//
//  ScaleSegue.swift
//  ADRE
//
//  Created by youngwoo Choi on 24/05/2019.
//  Copyright © 2019 youngwoo Choi. All rights reserved.
//

import UIKit

class ScaleSegue: UIStoryboardSegue {
    
    override func perform() {
        scale ()
    }
    
    func scale () {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.alpha = 0.0
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            toViewController.view.alpha = 1.0
        }, completion: { success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }
}
