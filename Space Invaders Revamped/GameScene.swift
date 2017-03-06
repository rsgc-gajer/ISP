// GameScence.Swift

// Space Invaders

// Created by Ryan Gajer

import SpriteKit

class GameScene : SKScene {
    
     let player = SKSpriteNode(imageNamed: "ship") // Import playermodel image
    
     let bulletSound = SKAction.playSoundFileNamed("missile_3.wav", waitForCompletion: false)
    
    // This function runs once at the start of the game
    
    override func didMove(to view: SKView) {
        // Background
        let background = SKSpriteNode(imageNamed: "stars") // Import the background image
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0 // Lowest zPosition meaning it will be behind everything
        self.addChild(background) // Add background to the scene
        
        // Player
        player.setScale(0.3) // Set player scale size
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/2 * 0.2) // Middle of the screen, up about 1/4 on screen
        self.zPosition = 2 // Will be above the background
        self.addChild(player)
    }
    
        // Bullet
        func bulletFired() {
            let bullet = SKSpriteNode(imageNamed: "bullet") // Import the bullet image
            bullet.setScale(0.5)
            bullet.position = player.position // Setting the bullet so it stays with the player model
            bullet.zPosition = 1 // Behind playermodel but in front of background
            self.addChild(bullet)
            
        // Implement bullet actions
            let bulletMovement = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1) // Move bullet along y axis only with the height of the window
            let bulletDelete = SKAction.removeFromParent()
            let bulletSequence = SKAction.sequence([bulletSound, bulletMovement, bulletDelete]) // Runs animation of bullet appearing and then deleting after duration
            bullet.run(bulletSequence) // Run the sequence
        }
        // Run bulletFired()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // Touch function for bullet, runs bulletFired func and implements touch force so that when you touch the screen, a bullet will be fired from set position at set speed 
        bulletFired()
    }
        // Move player on screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bulletFired()
    }
}

