//
//  GamoeOverScene.swift
//  Space Invaders Revamped
//
//  Created by Ryan Gajer on 2017-05-07.
//  Copyright © 2017 Ryan Gajer. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let restartText = SKLabelNode(fontNamed: "The Bold Font")

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "stars")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverText = SKLabelNode(fontNamed: "The Bold Font")
        gameOverText.text = "Game Over"
        gameOverText.fontSize = 200
        gameOverText.fontColor = SKColor.white
        gameOverText.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverText.zPosition = 1
        self.addChild(gameOverText)
        
        let scoreText = SKLabelNode(fontNamed: "The Bold Font")
        scoreText.text = "Score \(gameScore)"
        scoreText.fontSize = 125
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreText.zPosition = 1
        self.addChild(scoreText)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        let highScoreText = SKLabelNode(fontNamed: "The Bold Font")
        highScoreText.text = "HighScore \(highScoreNumber)"
        highScoreText.fontSize = 125
        highScoreText.fontColor = SKColor.white
        highScoreText.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        highScoreText.zPosition = 1
        self.addChild(highScoreText)
        
        restartText.text = "Restart"
        restartText.fontSize = 90
        restartText.fontColor = SKColor.white
        restartText.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        restartText.zPosition = 1
        self.addChild(restartText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            if restartText.contains(pointOfTouch) {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
