//
//  ViewController.swift
//  MatchGame
//
//  Created by Emily Shao on 2019-09-06.
//  Copyright © 2019 Emily Shao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var model = CardModel()
    var cardArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 25 * 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Call the getCards method of the function/model to replace array
        cardArray = model.getCards()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Timer Creation
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated
    }
    
    @objc func timerElapsed() {
        milliseconds -= 1
                let seconds = String(format: "%.2f", milliseconds/1000)
                timerLabel.text = "Timer: \(seconds)"

        if milliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // Check if there are any cards unmatched at end of game
            checkGameEnded()
        }
    }
    
    // MARK: UICollectionView Protocal
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    // to be called 16 times for each cell it needs to display
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card that collection view is trying to display
        let card = cardArray[indexPath.row]
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Check if there is time remaining
        if milliseconds <= 0 {
            return
        }
        // Get the cell and card the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
                let card = cardArray[indexPath.row]
        
        //Check flip status of card, flip, change isFlipped status
        if card.isFlipped == false && card.isMatched == false {
            cell.flip()
            SoundManager.playSound(.flip)
            card.isFlipped = true
            
            // Check if it is the first card flip in the turn
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            }
            else {
                checkForMatches(indexPath)
            }
        }
        
    }
    
    // MARK: Game Logic Methods
    func checkForMatches(_ secondFilppedCardIndex:IndexPath) {
        // Get cells and card of the revealed 2 cards
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFilppedCardIndex) as? CardCollectionViewCell

        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFilppedCardIndex.row]
        
        // Comparing the 2 cards
        if cardOne.imageName == cardTwo.imageName {
            SoundManager.playSound(.match)
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there are any cards left unmatched
            checkGameEnded()
        }
        else {
            SoundManager.playSound(.nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // Reload the cell of the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        //Determine if there any cards left
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        var title = ""
        var message = ""
        
        // If no cards, users won, stop timer
        if isWon == true {
            if milliseconds > 0 {
                timer?.invalidate()
            }
            title = "Congratulations!"
            message = "You've Won"
        }
        else {
            // If cards left, check if there's any time left
            if milliseconds > 0 {
                return
            }
            title = "Game Over"
            message = "You've Lost"
        }
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

