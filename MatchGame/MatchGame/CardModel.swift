//
//  CardModel.swift
//  MatchGame
//
//  Created by Emily Shao on 2019-09-06.
//  Copyright © 2019 Emily Shao. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        // Already generated numbers array
        var generatedNumbersArray = [Int]()
        
        // Already generated cards array
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards (8 pairs)
        while generatedNumbersArray.count < 8 {
            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                print(randomNumber)
                generatedNumbersArray.append(Int(randomNumber))
                
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardTwo)
            }
        }
        //Randomnize array
        for i in 0...generatedCardsArray.count-1 {
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        return generatedCardsArray
    }
}
