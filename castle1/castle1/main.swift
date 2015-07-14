//
//  main.swift
//  castle1
//
//  Created by Ernie Thompson on 7/5/15.
//  Copyright (c) 2015 Ernie Thompson. All rights reserved.
//

import Foundation

var ernie = KangarooCastle(kName: "Ernie's Castle")
var kyle = KangarooCastle(kName: "Kyle's Castle")
var john = KangarooCastle(kName: "John's Castle")
var joan = KangarooCastle(kName: "Joan's Castle")


var castles:[Castle] = [ernie, kyle, john, joan]
var turns:Int = 0


func randomPick (number: Int) -> Int {
    
    return Int(arc4random_uniform(UInt32(number)))
}

func play(){
    
    while (turns <= 1000 && castles.count > 1) {
        
        
        var ind = turns % castles.count
        var targetInd = (ind + (1 + randomPick(castles.count - 1))) % castles.count
        castles[ind].takeTurn(castles[targetInd])
        checkForDeadCastles()
        turns++
        
    }
    
    if (castles.count == 1) {
    
        println("After \(turns) turns...\(castles[0].castleName) IS VICTORIOUS!!!!".uppercaseString)
        
    } else {
        println("There was no clear victor after \(turns) turns...")
    }
    

}

func checkForDeadCastles() {

    var arrLength = castles.count
    
    for var i = 0; i < arrLength; i++ {
        
        if castles[i].isAlive == false {
            println("\(castles[i].castleName) IS NO MORE!!!".uppercaseString)
            
            castles.removeAtIndex(i)
            arrLength--
            i--
        }
    }

}

play()



