//
//  InterfaceController.swift
//  hues WatchKit Extension
//
//  Created by HansParker on 05/01/2019.
//  Copyright © 2019 HansParker. All rights reserved.
//

//time the current game started
//an dictionary colors we can choose from the game
//current level player is on
//replace the colors with something else funnier like bitcoinTicker or Chinese Character //

import WatchKit
import Foundation
import UserNotifications


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var tlButton: WKInterfaceButton!
    @IBOutlet weak var trButton: WKInterfaceButton!
    @IBOutlet weak var blButton: WKInterfaceButton!
    @IBOutlet weak var brButton: WKInterfaceButton!
    
    var buttons = [WKInterfaceButton]()
    
    var startTime = Date()
    
    var colors = [ "Red": UIColor.red,
                   "Green": UIColor.green,
                   "Blue": UIColor.blue,
                   "Purple": UIColor.purple,
                   "Black": UIColor.black,
                   "Orange": UIColor.orange]
    
    var currentLevel = 0
    
  
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        buttons = [tlButton, trButton, blButton, brButton]
        
        startNewGame()
        setPlayReminder()
        
//        buttons.shuffle()
//
//        let colorKeys = Array(colors.keys)
//
//        //assign colors randomly
//        for (index, button) in buttons.enumerated() {
//
//            button.setBackgroundColor(colors[colorKeys[index]])
//
//        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func levelUp() {
        currentLevel += 1
        //pull out the color names and shuffle them with the buttnslet colorKeys = Array(colors.keys)
        
        if currentLevel == 10 {
            
            //set the action
            let playAgain = WKAlertAction(title: "Play Again", style: .default) {
                self.startNewGame()
            }
            
            let timePassed = Date().timeIntervalSince(startTime)
            presentAlert(withTitle: "You Win!", message: "You finsihed in \(Int(timePassed)) seconds.", preferredStyle: .alert, actions: [playAgain])
            
            return
        }
        
        //
        var colorKeys = Array(colors.keys)
        buttons.shuffle()
        colorKeys = colorKeys.shuffled()
        
        //assign colors randomly
        for (index, button) in buttons.enumerated() {
            
            button.setEnabled(true)
            
            button.setBackgroundColor(colors[colorKeys[index]])
            
            if index == 0 {
                button.setTitle(colorKeys[colorKeys.count - 1])
            }
            else {
                button.setTitle(colorKeys[index])
            }
            
        }
    }
    
    
    @IBAction func startNewGame() {
        startTime = Date()
        currentLevel = 0
        levelUp()
        
    }
    
    @IBAction func tlButtonPressed() {
        buttontapped(tlButton)
    }
    @IBAction func trButtonPressed() {
        
        buttontapped(trButton)
    }
    @IBAction func blButtonPressed() {
        buttontapped(blButton)
    }
    @IBAction func brButtonPressed() {
        buttontapped(brButton)
    }
    
    func buttontapped(_ button: WKInterfaceButton){
        if button == buttons[0] {
            //correct Button!
            levelUp()
        }
        else {
            
        }
    }
    
    func createNotificaitons () {
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        
        content.title = "We miss you!"
        content.body = "Come back and play the game some more"
        content.categoryIdentifier = "play_reminder"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func setPlayReminder() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound])
        {success, error in
            
            if success {
                
                self.reegisterCategory()
                center.removeAllPendingNotificationRequests()
                self.createNotificaitons()
                
                
            }
        }
    }
    
    func reegisterCategory() {
        let center = UNUserNotificationCenter.current()
        let play = UNNotificationAction(identifier: "play", title: "Play Now", options: .foreground)
        let category = UNNotificationCategory(identifier: "play_reminder", actions: [play], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
}




//notification: UNNotifcationsOund.default
