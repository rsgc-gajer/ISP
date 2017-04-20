// GameScence.Swift

// Space Invaders

// Created by Ryan Gajer

import SpriteKit

class GameScene : SKScene {
    let enemy = SKSpriteNode(imageNamed: "alien ship")
    
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
        
        // Enemy 
        enemy.setScale(0.2)
        enemy.position = CGPoint(x: self.size.width/2, y: self.size.height)
        self.zPosition = 300
        self.addChild(enemy)
        
        // Create enemy movement pattern
        let moveLeft = SKAction.moveBy(x: -100, y: 0, duration: 1)
        let moveDown = SKAction.moveBy(x: 0, y: -100, duration: 1)
        let moveUP = SKAction.moveBy(x: 0, y: 100, duration: 1)
        let moveRight = SKAction.moveBy(x: 100, y: 0, duration: 1)
        
        let enemyMovement = SKAction.sequence([moveLeft, moveDown, moveRight, moveRight, moveDown, moveLeft])
        
        let repeatMovement = SKAction.repeatForever(enemyMovement) // Run the action more than once
        
        enemy.run(repeatMovement) // Run the enemy movement
    }
    
    override func update(_ currentTime: TimeInterval) {
        checkForHits()
    }
    
    
    func checkForHits() {
        
        // Loop through all the nodes that are bullets and find out which onees are intersecting with the aliens
        for node in self.children {
            
            // Getting the name of nodes that have had names assigned
            if let nodeName = node.name {
                
                // Only check for whether bullets are intersecting with the alien
                if nodeName == "bullet" {
                    
                    // See if it is intersecting the bullet
                    if node.intersects(enemy) {
                        print("hit")
                    } else {
                        print("no hit")
                    }
                    
                }
                
            }
            
            
        }
        
        
    }
    
    
    // Bullet
    func bulletFired() {
        let bullet = SKSpriteNode(imageNamed: "bullet") // Import the bullet image
        bullet.setScale(0.5)
        bullet.position = CGPoint(x: player.position.x, y: player.position.y + player.size.height/1.6) // Setting the bullet so it stays with the player model
        bullet.zPosition = 1 // Behind playermodel but in front of background
        bullet.name = "bullet"
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
        
    // Make the ship move
        guard let touch = touches.first else { // Fingers are big when we touch device
            return
    }
    // Get the location of the first touch
        let touchLocation = touch.location(in: self)
        
        movePlayer(touchLocation: touchLocation) // Use the movePlayer method
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self) // Get the location of the first touch
        
        movePlayer(touchLocation: touchLocation)
    }
    func movePlayer(touchLocation: CGPoint) {
        let destination = CGPoint(x: touchLocation.x, y: player.position.y) // Make player move horizontally
        let actionMove = SKAction.move(to: destination, duration: 0.1)
        player.run(actionMove) // Run the function
    }
    func moveEnemy() {
        
    }
    
}

