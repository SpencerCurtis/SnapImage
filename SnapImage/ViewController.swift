//
//  ViewController.swift
//  SnapImage
//
//  Created by Spencer Curtis on 1/6/17.
//  Copyright © 2017 Spencer Curtis. All rights reserved.
//

import UIKit

// It's been a while since I looked at this, so I'm not sure if this has any code that the TestViewController does not have already. I'll check it later.

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var isFullScreen = false
    
    var originalFrame = CGRect.zero
    
    var originalContentMode = UIViewContentMode.scaleAspectFit
    
    var darkBackgroundView: UIView!
    
    var dragStartPositionRelativeToCenter: CGPoint?
    
    var expandImageViewTapGestureRecognizer: UITapGestureRecognizer!
    var moveImageViewTapGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkBackgroundView = UIView(frame: self.view.frame)
        darkBackgroundView.backgroundColor = .black
        darkBackgroundView.alpha = 0
        
        self.view.insertSubview(darkBackgroundView, belowSubview: imageView)
        
        expandImageViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(expandImageView))
        moveImageViewTapGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        
        expandImageViewTapGestureRecognizer.delegate = self
        moveImageViewTapGestureRecognizer.delegate = self
        
        imageView.addGestureRecognizer(moveImageViewTapGestureRecognizer)
        imageView.addGestureRecognizer(expandImageViewTapGestureRecognizer)
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
        guard isFullScreen else { return }
        switch sender.state {
            
            
        case .began:
            let locationInView = sender.location(in: self.view)
            dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - imageView.center.x, y: locationInView.y - imageView.center.y)
            
            return
            
            
        case .ended:
            
            print(sender.velocity(in: self.view).y)
            dragStartPositionRelativeToCenter = nil
            
            if sender.velocity(in: self.view).x > 900 || sender.velocity(in: self.view).x < -900, sender.velocity(in: self.view).y > 900 || sender.velocity(in: self.view).y < -900 {
                self.expandImageView()
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.imageView.center = self.view.center
                })
            }
        case .changed:
            
            let locationInView = sender.location(in: self.view)
            
            UIView.animate(withDuration: 0.1) {
                self.imageView.center = CGPoint(x: locationInView.x - self.dragStartPositionRelativeToCenter!.x,
                                                y: locationInView.y - self.dragStartPositionRelativeToCenter!.y)
            }
            
        default:
            break
        }
    }
    
    func expandImageView() {
        if !isFullScreen {
            originalFrame = imageView.frame
            originalContentMode = imageView.contentMode
            
            self.imageView.contentMode = .scaleAspectFit
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.darkBackgroundView.alpha = 0.5
                self.imageView.frame = self.view.bounds
                
            }, completion: { (_) in
                
                guard let image = self.imageView.image else { return }
                
                
                let width = self.view.frame.width
                
                let newImageViewheight = (width * ((image.size.height) / (image.size.width)))
                
                self.imageView.frame.size.height = newImageViewheight
                self.imageView.center = self.view.center
                self.isFullScreen = true
            })
            
        } else {
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                self.darkBackgroundView.alpha = 0.0
                self.imageView.frame = self.originalFrame
                self.view.layoutIfNeeded()
                self.imageView.contentMode = self.originalContentMode
            }, completion: { (_) in
                self.isFullScreen = false
            })
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith
        otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
