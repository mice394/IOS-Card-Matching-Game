//
//  CardCollectionViewCell.swift
//  MatchGame
//
//  Created by Emily Shao on 2019-09-07.
//  Copyright © 2019 Emily Shao. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card: Card) {
        self.card = card
        frontImageView.image = UIImage(named: card.imageName)
        
        // If card is matched, make the transparent
        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        }
        else {
            // If card is not matched, don't make it transparent
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        //Determine card status's of isFlipped
        if card.isFlipped == true {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else {
            UIView.transition(from: frontImageView, to: backImageView, duration: 0
                , options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        
    }
    
    func flip() {
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    
    func remove() {
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
