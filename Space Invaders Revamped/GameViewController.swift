//
//  GameViewController.swift
//  Space Invaders Revamped
//
//  Created by Ryan Gajer on 2017-02-28.
//  Copyright © 2017 Ryan Gajer. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: CGSize(width: 1536, height: 2048))
                // Configure the view
                let skView = self.view as! SKView
                skView.showsFPS = true
                skView.showsNodeCount = true
        
                // Improve rednering performance
                skView.ignoresSiblingOrder = true
        
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
