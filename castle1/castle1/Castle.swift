//
//  Castle.swift
//  castle1
//
//  Created by Ernie Thompson on 7/5/15.
//  Copyright (c) 2015 Ernie Thompson. All rights reserved.
//

import Foundation


class Castle {
    
    var castleName:String = "blank"
    
    private var _health:Int = 1000
    private var _popul:Int = 1000
    private var _food:Int = 1000
    private var _money:Int = 10000
    private var _aggression:Int = 100
    private var _growthRate:Float = 0.1
    
    private var _longTermImpediment:(()->(Bool))? = nil
    
    private var _availableAttacks:[Castle -> ()] = []
    private var _availableAttackNames:[String] = []
    
    private var _specialAttacks:[()->((Castle)->(), String)?] = []
    
    var  isAlive = true
    

    
    
    
    //getters////////////////////////////////////
    var health:Int {
        get {
            return self._health
        }
    }
    var popul:Int {
        get {
            return self._popul
        }
    }
    var food:Int {
        get {
            return self._food
        }
    }
    var money:Int {
        get{
            return self._money
        }
    }
    var aggression:Int {
        get{
            return self._aggression
        }
    }
    
    
    
    
    
    init(myName:String) {
    
        castleName = myName
    
    }
    
    
    
    
    func randomPick (number: Int) -> Int {
    
        return Int(arc4random_uniform(UInt32(number)))
    }
    
    
    
    
    func takeTurn (target: Castle) {
        
        println("\(self.castleName)'s turn:")
    
        if (_longTermImpediment == nil || _longTermImpediment!() == false) &&
            (checkBasicNeeds() == true) {
            
                updateAttacks()
                
                var randIndex = randomPick(_availableAttacks.count)
                var theFunc = _availableAttacks[randIndex]
                theFunc(target)
                
            
        }
        
    
    }
    
    
    
    private func updateAttacks() {
        
        _availableAttacks = [steal, startFire]
        _availableAttackNames = ["Steal", "StartFire"]
        
        for atk in _specialAttacks {
            
            var attack = atk()
            if attack != nil {
                _availableAttacks.append(attack!.0)
                _availableAttackNames.append(attack!.1)
            }
        }
        
        println("   Available attacks/moves: \(_availableAttackNames)")
        
    }
    
    private func checkBasicNeeds() -> Bool {
        
        if _health < 50 {
            dHealth(100)
            println("   " + self.castleName + " needed to spend this turn tending to the healthcare struggles of its subjects!\n    Health is now at " + String(_health) + ".")
            return false
        }
        
        if _food < 50 {
            dFood(100)
            println("   " + self.castleName + " needed to spend this turn battling malnutrition!\n  Food has increased to " + String(_food) + ".")
            return false
        }
        
        return true
        
    }
    
    
    
    
    
    func sufferAttack (attack: (h:Int, p:Int, f:Int, m:Int, a:Int, canEvade: Bool), attacker: Castle) {
        
        dHealth(-attack.h)
        dPopul(-attack.p)
        dFood(-attack.f)
        dMoney(-attack.m)
        dAggression(-attack.a)
        
        
    }
    
    
    
    func sufferFire () {
     
        var hdamage = -Int(arc4random_uniform(UInt32(_health/10)))
        var pdamage = -Int(arc4random_uniform(UInt32(_popul/10)))
        var fdamage = -Int(arc4random_uniform(UInt32(_food/10)))
        var mdamage = -Int(arc4random_uniform(UInt32(_money/10)))
        var adamage =  Int(arc4random_uniform(UInt32(_aggression/10)))
        
        dHealth(hdamage)
        dPopul(pdamage)
        dFood(fdamage)
        dMoney(mdamage)
        dAggression(adamage)
        
        println("     POST-FIRE REPORT for \(self.castleName):\n        Health: \(health) (\(hdamage))\n        Pop: \(popul) (\(pdamage))\n        Food: \(food) (\(fdamage))\n        Money: \(money) (\(mdamage))\n        Aggression: \(aggression) (+\(adamage))")
        
    }
    
    
   
    
    
    
    func sampleLongTermAttack (victim: Castle) {
    
        println("\(self.castleName) poisoned \(victim.castleName)!!")
        
        var numberRounds:Int = 3
        
        func sampleImpediment () -> Bool {
            
            if numberRounds > 0 {
                
                victim.health - 10
                println("   \(victim.castleName) lost 10 health from poison!")
                numberRounds--
           
            } else {
                
                victim._longTermImpediment = nil
                
                println("   \(victim.castleName) recovered from poison!")
              
            }
            
            return false //true causes player to skip turn.
            
        
        }
        
        victim.longTermImpediment = sampleImpediment
        
        
    }
    
    
    private func steal (victim: Castle) -> (){
        
        
        var stolenMoney:Int = Int(arc4random_uniform(UInt32(victim.money/10)))
        var stolenFood:Int = Int(arc4random_uniform(UInt32(victim.food/10)))
        
        victim.sufferAttack((0,0,stolenFood,stolenMoney,0,false), attacker: self)
        
        dMoney(stolenMoney)
        dFood(stolenFood)
        
        println("   " + self.castleName + " stole \(stolenFood) food and \(stolenMoney) money from \(victim.castleName)!")
    
    }
    
    func startFire (victim: Castle) -> () {
        
        println("   " + self.castleName + " set fire to " + victim.castleName + "!")
        victim.sufferFire()

    }
    

    //getter/setter for _longTermImpediment. Long term attack will not work if victim
    //is still suffering from another long term attack.
    var longTermImpediment:(()->(Bool))? {
        get {
            return self._longTermImpediment
        }
        
        set {
            if self._longTermImpediment == nil {
                
                self._longTermImpediment = newValue
                
            } else {
                
                println("   ...but it had no effect because \(self.castleName) is already dealing with another issue!")
            }
        }
        
    }
    
    func dHealth(num: Int) {
        _health += num
        if _health <= 0 {
            _health = 0
            
        }
    }
    
    func dPopul(num: Int) {
        _popul += num
        if _popul <= 0 {
            _popul = 0
            isAlive = false
        }
    }
    
    func dFood(num: Int) {
        _food += num
        if _food <= 0 {
            _food = 0
        }
    }
    
    func dMoney(num: Int) {
        _money += num
        if _money <= 0 {
            _money = 0
        }
    }
    
    
    
    func dAggression(num: Int) {
        _aggression += num
        if _aggression <= 0 {
            _aggression = 0
        }
    }
    
}



class KangarooCastle : Castle {
    
    var rubber:Int = 100
    var trampolines:Int = 50
    
    init(kName:String){
        
        super.init(myName: kName)
        
        _specialAttacks = [checkKangarooCourt, checkRapidKick, checkStampede, checkDeathThrash]
        
    }
    
    func checkKangarooCourt() -> (((Castle)->(), String)?) {
        
        func kangarooCourt(victim:Castle) ->() {
            
            var numRounds = 1 + randomPick(3)
            var fine = randomPick(500)
            
            println("   \(self.castleName) dragged \(victim.castleName) into Kangaroo Court!")
            println("   \(self.castleName) awarded itself a recurring fine of $\(fine) from \(victim.castleName) for \(numRounds) round(s)!")
            
            func court() -> Bool {
                
                if (numRounds > 0) {
                    
                    victim.dMoney(-fine)
                    self.dMoney(fine)
                    
                    print("   \(victim.castleName) paid $\(fine) in fines to \(self.castleName)!")
                    return false
                    
                } else {
                    victim._longTermImpediment = nil
                    print("   \(victim.castleName) finished paying its fines to \(self.castleName)!")
                    return false
                }
                
            }
            
            victim.longTermImpediment = court
            
        }
        
        return (kangarooCourt, "KangarooCourt")
        
        
    }
    
    func checkRapidKick() -> (((Castle)->(), String)?) {
    
    }
    
    
    func checkStampede () -> (((Castle)->(), String)?) {
    
    }
    
    func checkDeathThrash () -> (((Castle)->(), String)?) {
    
    }
    
}


