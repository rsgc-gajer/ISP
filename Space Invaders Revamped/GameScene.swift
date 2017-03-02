// GameScence.Swift

// Space Invaders

// Created by Ryan Gajer

import SpriteKit

class GameScene : SKScene {
    
     let player = SKSpriteNode(imageNamed: "ship") // Import playermodel image
    
    // This function runs once at the start of the game
    
    override func didMove(to view: SKView) {
        // Background
        let background = SKSpriteNode(imageNamed: "stars") // Import the background image
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0 // Lowest zPosition meaning it will be behind everything
        self.addChild(background) // Add background to the scene
        
        // Player
        player.setScale(0.9) // Set player scale size
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/2 * 0.2) // Middle of the screen, up about 1/4 on screen
        self.zPosition = 2 // Will be above the background
        self.addChild(player)
    }
    
        // Bullet
        func bulletFired() {
            let bullet = SKSpriteNode(imageNamed: "bullet") // Import the bullet image
            bullet.setScale(1)
            bullet.position = player.position // Setting the bullet so it stays with the player model
            bullet.zPosition = 1 // Behind playermodel but in front of background
            self.addChild(bullet)
            
        // Implement bullet actions
            let bulletMovement = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1) // Move bullet along y axis only with the height of the window
            let bulletDelete = SKAction.removeFromParent()
            let bulletSequence = SKAction.sequence([bulletMovement,bulletDelete]) // Runs animation of bullet appearing and then deleting after duration
            bullet.run(bulletSequence) // Run the sequence
        }
        // Run bulletFired()
        
    }
//}
