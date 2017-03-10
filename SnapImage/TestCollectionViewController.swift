//
//  TestCollectionViewController.swift
//  SnapImage
//
//  Created by Spencer Curtis on 1/6/17.
//  Copyright © 2017 Spencer Curtis. All rights reserved.
//

import UIKit

class TestCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout {
    
    
    var isFullScreen = false
    
    var originalFrame = CGRect.zero
    
    var originalContentMode = UIViewContentMode.scaleAspectFit
    
    var darkBackgroundView: UIView!
    
    var dragStartPositionRelativeToCenter: CGPoint?
    
    var cards: [Card] = []
    
    var tappedCell: ImageCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkBackgroundView = UIView(frame: self.view.frame)
        darkBackgroundView.backgroundColor = .black
        darkBackgroundView.alpha = 0
        
        self.view.addSubview(darkBackgroundView)
        
        CardController.draw(numberOfCards: 52) { (cards) in
            
            let group = DispatchGroup()
            
            self.cards = cards
            
            for card in self.cards {
                group.enter()
                ImageController.image(forURL: card.imageEndpoint, completion: { (image) in
                    guard let image = image else { group.leave(); return }
                    card.image = image
                    group.leave()
                })
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                self.collectionView?.reloadData()
            })
        }
        
    }
    
    func expandImageViewIn(cell: ImageCollectionViewCell) {
        
        guard let imageView = cell.imageView else { return }
        
        if !isFullScreen {
            
            self.tappedCell = cell
            
            originalFrame = self.view.convert(imageView.frame, from: imageView.superview)
            originalContentMode = imageView.contentMode
            
            let expandingImageView = UIImageView(image: imageView.image)
            expandingImageView.contentMode = .scaleAspectFit
            
            
            expandingImageView.frame = originalFrame
            expandingImageView.isUserInteractionEnabled = true
            expandingImageView.clipsToBounds = true
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                self.view.addSubview(expandingImageView)
                cell.imageView.image = UIImage()

                expandingImageView.frame = self.view.bounds
                
                
                self.darkBackgroundView.alpha = 0.5
            }, completion: { (_) in
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImageView(sender:)))
                expandingImageView.addGestureRecognizer(tap)
                
                guard let image = expandingImageView.image else { return }
                
                let width = self.view.frame.width
                
                let newImageViewheight = (width * ((image.size.height) / (image.size.width)))
                
                expandingImageView.frame.size.height = newImageViewheight
                expandingImageView.center = self.view.center
                
                self.isFullScreen = true
            })
        }
    }
    
    func dismissFullscreenImageView(sender: UITapGestureRecognizer) {
        guard let expandingImageView = sender.view as? UIImageView else { return }
        
        expandingImageView.contentMode = self.originalContentMode
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
            
            sender.view?.frame = self.originalFrame
            
            self.darkBackgroundView.alpha = 0.0
            
            self.view.layoutIfNeeded()
            
        }, completion: { (_) in
            sender.view?.removeFromSuperview()
            
            self.isFullScreen = false
            
            guard let cell = self.tappedCell else { return }
            cell.imageView.image = expandingImageView.image
        })
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith
        otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else { return }
        expandImageViewIn(cell: cell)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        let card = cards[indexPath.row]
        
        guard let image = card.image else { return UICollectionViewCell() }
        
        cell.updateWith(image: image)
        
        return cell
    }
}
