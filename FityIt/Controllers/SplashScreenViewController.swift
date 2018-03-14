//
//  SplashScreenViewController.swift
//  FityIt
//
//  Created by Txai Wieser on 13/03/18.
//  Copyright © 2018 Txai Wieser. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GCHelper.sharedInstance.authenticateLocalUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GameSingleton.instance.initializeInitialScreenBackgroundTexture(InitialScene.calculateSceneSize(self.view.frame.size))
        
        delay(0.2) {
            GameSingleton.instance.initializeGameTextures(GameScene.calculateSceneSize(self.view.frame.size))
            GameSingleton.instance.resetSounds()
        }
        
        delay(0.4) {
            _ = AppDelegate.gameViewController
        }
        
        delay(0.6) {
            let vc = AppDelegate.gameViewController
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
}