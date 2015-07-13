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
    private var _unavailableAttackNames:[String] = []
    
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
    
   
    func arrayToTabbedList (arr:[String]) -> String {
        
        var list:String = ""
        
        for item in arr {
            
            list += "\n      \(item)"
        
        }
        
        return list
    
    }
    
    
    
    func takeTurn (target: Castle) {
        
        println("\(self.castleName)'s turn:")
        
        printStats("Starting stats: ")
        print("\n")
        manageResources()
    
        if (_longTermImpediment == nil || _longTermImpediment!() == false) &&
            (checkBasicNeeds() == true) {
            
                updateAttacks()
                
                var randIndex = randomPick(_availableAttacks.count)
                var theFunc = _availableAttacks[randIndex]
                theFunc(target)
                
            
        }
        
        printStats("Ending stats: ")
        print("\n")
        
    
    }
    
    
    
    private func updateAttacks() {
        
        _availableAttacks = [steal, startFire]
        _availableAttackNames = ["Steal", "StartFire"]
        _unavailableAttackNames = []
        
        for atk in _specialAttacks {
            
            var attack = atk()
            if attack != nil {
                _availableAttacks.append(attack!.0)
                _availableAttackNames.append(attack!.1)
            }
        }
        
        println("   Available attacks/moves:\(arrayToTabbedList(_availableAttackNames))")
        println("   Unavailable:\(arrayToTabbedList(_unavailableAttackNames))")
        
    }
    
    
    
    private func manageResources() {
    
        if (money <= 50) {
            
            var popDown = -10 - randomPick(40)
            
            dPopul(popDown)
            println("   \(popDown) subjects have left due to economic hardships!")
        
        }
        
        if (food <= 50) {
            
            var popDown = -10 - randomPick(40)
            
            dPopul(popDown)
            println("   \(popDown) subjects have left due to food shortages!")
            
        }
    
    }
    
    func printStats(opening:String) {
    
    print("   \(opening) health: \(health), population: \(popul), food: \(food), money: \(money), aggression: \(aggression)")
    
    }
    
    
    private func checkBasicNeeds() -> Bool {
        
        if _health < 10 {
            dHealth(100)
            println("   " + self.castleName + " needed to spend this turn tending to the healthcare struggles of its subjects!\n    Health is now at " + String(_health) + ".")
            return false
        }
        
        if _food < 10 {
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
        
        println("     POST-FIRE REPORT for \(self.castleName):\n        health: \(health) (\(hdamage))\n        pop: \(popul) (\(pdamage))\n        food: \(food) (\(fdamage))\n        money: \(money) (\(mdamage))\n        aggression: \(aggression) (+\(adamage))")
        
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
    var trampolines:Int = 4
    
    init(kName:String){
        
        super.init(myName: kName)
        
        _specialAttacks = [checkKangarooCourt, checkRapidKick, checkBouncingBrigade, checkDeathMarch]
        
    }
    
    
    override func printStats(subopening: String) {
        super.printStats(subopening)
        print(", rubber: \(rubber), trampolines: \(trampolines)")
    }
    
    override func sufferFire() {
        
        super.sufferFire()
        var damageTrampolines = randomPick(trampolines/4)
        var damageRubber =  randomPick(rubber/4)
        
        dTrampolines(-damageTrampolines)
        dRubber(-damageRubber)
        
        println("        rubber: \(rubber) (-\(damageRubber))\n        trampolines: \(trampolines) (-\(damageTrampolines))")
        
    }
    
    
    override func sufferAttack(attack: (h: Int, p: Int, f: Int, m: Int, a: Int, canEvade: Bool), attacker: Castle) {
    
        var jumpNum = randomPick(4)
        
        if (jumpNum == 1 && attack.canEvade == true) {
            
            println("   \(self.castleName) completely evaded the attack by jumping into the air!")
            
        } else {
            
            dHealth(-attack.h)
            dPopul(-attack.p)
            dFood(-attack.f)
            dMoney(-attack.m)
            dAggression(-attack.a)
            
            println("\(self.castleName) suffered the full brunt of the attack!")
            
        }
        
    }
    
    override func manageResources() {
    
        super.manageResources()
        
        
    }
    
    
    
    func dRubber(num:Int) {
        
        rubber += num
        if rubber <= 0 {
            rubber = 0
        }
    
    
    }
    
    func dTrampolines(num:Int) {
    
        trampolines += num
        if trampolines <= 0 {
            trampolines = 0
        }
        
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
        
        
        var hasReqs:Bool = false
        
        if (self.aggression >= 105 && self.money >= 150 && self.health >= 300) {
            
            hasReqs = true
        }
        
        
        func rapidKick (victim:Castle) ->() {
            
            var i = 1 + randomPick(4)
            var numTimes = i
            var damage = 60
      
            
            
            while (i > 0) {
                
                println("   Kick!")
                i--
            
            }
            
            println("   \(self.castleName) used RapidKick on \(victim.castleName), and kicked \(numTimes) time(s)!")
            println("   \(self.castleName) dealt a total of \(numTimes*damage) health damage!")
            victim.sufferAttack((numTimes*damage, 0, 0, 0, 0, true), attacker: self)
            self.dMoney(-150)

            
        }
        
        if (hasReqs){
        
            return (rapidKick, "RapidKick (cost: m 50)")
        
        } else {
        
            _unavailableAttackNames.append("RapidKick (req: a ≥ 105, h ≥ 300, m ≥ 50)")
            return nil
        }
        
        
        
    }

    
    
    
    
    func checkBouncingBrigade () -> (((Castle)->(), String)?) {
        
        var hasReqs = false

        
        if (aggression >= 120 && trampolines >= 10 && money >= 750) {
            hasReqs = true
        }
        
        func bouncingBrigade(victim: Castle) {
            
            var damageHealth = 100 + randomPick(200)
            var damagePop = 100 + randomPick(200)
            
            
            println("   \(self.castleName) sent out the Bouncing Bringade!")
            println("   The Bouncing Brigade set out to do \(damageHealth) health damage and liquidate \(damagePop) subjects of \(victim.castleName)!")
            victim.sufferAttack((damageHealth, damagePop, 0, 0, 0, true), attacker: self)
            dMoney(-750)
            
        }
        
        if (hasReqs) {
        
            return (bouncingBrigade, "BouncingBrigade (cost: m 750)")
        
        } else {
            
            _unavailableAttackNames.append("BouncingBrigade (req: m ≥ 750, a ≥ 120, trampolines ≥ 10)")
            return nil
            
        }
        
        
        
    
    }
    
    func checkDeathMarch () -> (((Castle)->(), String)?) {
        
        var hasReqs = false
        
        if (health <= 70 || popul <= 70) {
        
            hasReqs = true
            
        }
        
        func deathMarch(victim: Castle){
            
            var hdamage = 500 + self.aggression*2
            
            println(
            "   With the very existence of the kingdom in the balance, every kangaroo has volunteered" +
            "\n   his/her own life for the very dream that their castle may survive into the eons! They\n" +
            "   have gone on a DEATH MARCH.")
            
            self._health = 1
            self._popul = 1
           
            victim.sufferAttack((hdamage, 0, 0, 0, 0, true), attacker: self)
            
            println("   Although the inhabitants of \(self.castleName) were able to commit a heroic amount of damage,\n   the civilian cost was enourmous.")
            
        
        }
        
        if (hasReqs) {
        
            return (deathMarch, "DeathMarch (cost: h \(health - 5), p \(popul - 5))")
        
        } else {
            
            _unavailableAttackNames.append("DeathMarch (req: h/p ≤ 70)")
            return nil
            
        }
        
    
    }
    
}


