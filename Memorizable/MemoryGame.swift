//
//  MemoryGame.swift
//  Memorizable
//
//  Created by Samuel Pinheiro Junior on 06/07/20.
//  Copyright © 2020 Samuel Pinheiro Junior. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex: Int = cards.firstIndex(matching: card), !self.cards[chosenIndex].isFaceUp, !self.cards[chosenIndex].isMatched {
            if let potentialMatchingIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchingIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchingIndex].isMatched = true
                }
                self.cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonnusTime()
                } else {
                    stopUsingBonnusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonnusTime()
            }
        }
        var content: CardContent
        var id: Int




        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        var bonnusTimeRemaning: Double {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonnusRemaning: Double {
            (bonusTimeLimit > 0 && bonnusTimeRemaning > 0) ? bonnusTimeRemaning/bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonnusTimeRemaning > 0
        }

        var isConsummingBonnusTime: Bool {
            isFaceUp && !isMatched && bonnusTimeRemaning > 0
        }

        private mutating func startUsingBonnusTime() {
            if isConsummingBonnusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonnusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
            
        }
    }
}
