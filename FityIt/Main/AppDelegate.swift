//
//  AppDelegate.swift
//  FityIt
//
//  Created by Txai Wieser on 13/03/18.
//  Copyright © 2018 Txai Wieser. All rights reserved.
//

import UIKit
import Skillz

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SkillzDelegate {
    static var instance: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    static var gameViewController: GameViewController { return instance.gameViewController }
    
    var window: UIWindow?
    private lazy var gameViewController = GameViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Skillz.skillzInstance().initWithGameId("5675", for: self, with: SkillzEnvironment.production, allowExit: true)
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        window!.makeKeyAndVisible()
        window!.rootViewController = SplashScreenViewController()
        return true
    }
    
    func tournamentWillBegin(_ gameParameters: [AnyHashable : Any]!, with matchInfo: SKZMatchInfo!) {
        print("Starting Skillz Tournament")

        #if DEBUG && !SNAPSHOT
            BUILD_MODE = .debug
        #else
            BUILD_MODE = .release
        #endif
        
        AppDelegate.gameViewController.gameView.presentScene(GameScene(), transition: AppDefines.Transition.toInitial)
        
//        window!.rootViewController = SplashScreenViewController()

    }

    func preferredSkillzInterfaceOrientation() -> SkillzOrientation {
        return SkillzOrientation.portrait
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
    
    /**
     #Set Oreientation
     
     Skillz requires the oreintation to be fixed and currently does not supprt changing orientation during runtime.
     
     */
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        AppPersistence.matchesPlayedSinceLaunch = 0
        if let gameScene = gameViewController.gameView.scene as? GameScene {
            gameScene.updateTimer.lap()
        }
    }
}

