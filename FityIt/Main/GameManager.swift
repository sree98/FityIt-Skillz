//
//  GameManager.swift
//  FityIt
//
//  Created by Sreekuttan Sudarsanan on 6/19/19.
//  Copyright © 2019 Txai Wieser. All rights reserved.
//

import Foundation
import UIKit
import Skillz

class GameManager : NSObject, SkillzDelegate {
    
    var window: UIWindow?
    
    /**
     Then tournamentWillBegin method is called when a player selects a tournament.
     
     -Parameter: gameParameters The array of game parameters which can be used to customize the tournament.
     -Parameter: matchInfo The SKZMatchInfo instance that provides match meta data such as match id and a list of players.
     
     Here we present the GameViewCOntroller that implements the main game interface.
     */
    func tournamentWillBegin(_ gameParameters: [AnyHashable : Any]!, with matchInfo: SKZMatchInfo!) {
        print("Starting Skillz Tournament")
        
        #if DEBUG && !SNAPSHOT
        BUILD_MODE = .debug
        #else
        BUILD_MODE = .release
        #endif
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        window!.makeKeyAndVisible()
        window!.rootViewController = SplashScreenViewController()
    }
    
    func preferredSkillzInterfaceOrientation() -> SkillzOrientation {
        return SkillzOrientation.portrait
    }
    
    func setMainWindow(window: UIWindow) {
        print("setting UIWindow in Game Manager")
        self.window = window
        print("after setting UIWindow in Game Manager")
    }
    
    /**
     * This method will be called when the Skillz SDK will exit.
     */
    func skillzWillExit() {
        print("skillzWillExit")
    }
    
    /**
     * This method will be called before the Skillz UI launches. Use this to clean up any state needed before you launch Skillz.
     */
    func skillzWillLaunch() {
        print("skillzWillLaunch")
    }
    
    /**
     * This method will be called once the Skillz UI has finished displaying. Use this to clean up your view hierarchy.
     */
    func skillzHasFinishedLaunching() {
        print("skillzHasFinishedLaunching")
    }
    
    
}
