// GameScence.Swift

// Space Invaders

// Created by Ryan Gajer

import SpriteKit

var gameScore = 0

class GameScene : SKScene, SKPhysicsContactDelegate {
    
    let scoreText = SKLabelNode(fontNamed: "The Bold Font")
    var livesNumber = 3
    let livesText = SKLabelNode(fontNamed: "The Bold Font")
    
    let player = SKSpriteNode(imageNamed: "ship") // Import playermodel image
    
    let bulletSound = SKAction.playSoundFileNamed("missile_3.wav", waitForCompletion: false)
    
    let tapToStart = SKLabelNode(fontNamed: "The Bold Font")
    
    enum gameState {
        case preGame // before game
        case inGame // playing in game
        case afterGame // after player died
    }
    var currentGameState = gameState.preGame
    
    struct boxCategories { // create categories for each node so that we can specify what can hit what. Using binary to define this
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 // 1
        static let Bullet : UInt32 = 0b10 // 2
        static let Enemy : UInt32 = 0b100 // 4
    }
    
    func random() -> CGFloat { // Making a random function instead so I have a variable named instead of using arc4random
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF) // returning arc4random as a variable
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max-min) + min // Generating us a random value between max and min range. For example we give 1-5, it will pick a number between 1 and 5
    }
    
    var gameArea: CGRect
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0 // Set ratio of box for playable area
        let playableWidth = size.height / maxAspectRatio // Sets playable width boundries
        let margin = (size.width - playableWidth) / 2 // Creates 2 smalelr boxes on sides of game
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height) // Create the game area subtracting margin sides
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) { // needed in order for CGSize to run
        fatalError("init(coder:) has not been implemented")
    }
    

    
    // This function runs once at the start of the game
    
    override func didMove(to view: SKView) {
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1 {
        
        // Background
        let background = SKSpriteNode(imageNamed: "stars") // Import the background image
        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2*CGFloat(i))
        background.zPosition = 0 // Lowest zPosition meaning it will be behind everything
        background.name = "Background"
        self.addChild(background) // Add background to the scene
        }
        
        // Player
        player.setScale(0.3) // Set player scale size
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height) // Middle of the screen, up about 1/4 on screen
        self.zPosition = 2 // Will be above the background
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size) // Adds player hitbox
        player.physicsBody!.affectedByGravity = false // Bool command, player is not affected by gravity
        player.physicsBody!.categoryBitMask = boxCategories.Player // set box category for player
        player.physicsBody!.contactTestBitMask = boxCategories.Enemy // allow player to collide with nothing(except enemy)
        self.addChild(player)
        
        scoreText.text = "Score 0"
        scoreText.fontSize = 70
        scoreText.fontColor = SKColor.white
        scoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left // makes sure text doesn't go off screen
        scoreText.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreText.frame.size.height)
        scoreText.zPosition = 50
        self.addChild(scoreText)
        
        livesText.text = "Lives 3"
        livesText.fontSize = 70
        livesText.fontColor = SKColor.white
        livesText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right // makes sure text doesn't go off screen
        livesText.position = CGPoint(x: self.size.width*0.85, y: self.size.height + livesText.frame.size.height)
        livesText.zPosition = 50
        self.addChild(livesText)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        scoreText.run(moveOnToScreenAction)
        livesText.run(moveOnToScreenAction)
        
        tapToStart.text = "Tap To Begin"
        tapToStart.fontSize = 100
        tapToStart.fontColor = SKColor.white
        tapToStart.zPosition = 1
        tapToStart.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStart.alpha = 0 // Transparent
        self.addChild(tapToStart)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStart.run(fadeInAction)
        
    }
    
    // Move the background
//    var lastUpdateTimne = 0
//    var deltaFrameTime = 0
//    var amountToMovePerSecond: CGFloat = 600
//    
//    override func update(_ currentTime: TimeInterval) {
//        if lastUpdateTimne == 0 {
//            lastUpdateTimne = Int(currentTime)
//        } else {
//            deltaFrameTime = Int(currentTime) - lastUpdateTimne
//            lastUpdateTimne = Int(currentTime)
//        }
//        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
//        
//        self.enumerateChildNodes(withName: "Background") { (background, stop) in
//            
//            if self.currentGameState == gameState.inGame {
//            background.position.y -= amountToMoveBackground
//            }
//            if background.position.y < -self.size.height {
//                background.position.y += self.size.height*2
//            }
//        }
//    }
    
    func startGame() {
        currentGameState = gameState.inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStart.run(deleteSequence)
        
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction])
        player.run(startGameSequence)
    }
    
    func loseLives() {
        livesNumber -= 1
        livesText.text = "Lives \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesText.run(scaleSequence)
        
        if livesNumber == 0 {
            gameOver()
        }
    }
    
    func addScore() {
        gameScore += 1
        scoreText.text = "Score: \(gameScore)"
        
    }
    
    func gameOver() {
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "bullet") { (bullet, stop) in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "enemy") { (enemy, stop) in
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func changeScene() {
        let sceneMoveTo = GameOverScene(size: self.size)
        sceneMoveTo.scaleMode = self.scaleMode // Keeping the scene in the same scale mode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneMoveTo, transition: myTransition)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // hit detection function
        var body1 = SKPhysicsBody() // Declare Bodies for enemy and player models
        var body2 = SKPhysicsBody() // Declare Bodies for enemy and player models
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == boxCategories.Player && body2.categoryBitMask == boxCategories.Enemy { // if the player htis the enemy
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            gameOver()
            
        }
        if body1.categoryBitMask == boxCategories.Bullet && body2.categoryBitMask == boxCategories.Enemy { // if the bulelt hits the enemy
            addScore()
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    
    func respawnEnemies() {
        let spawn = SKAction.run(spawnEnemy) // Run spawnEnemy
        let waitToSpawn = SKAction.wait(forDuration: 1) // Wait 1 second to restart once all enemies have left screen
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn]) // Spawn enemies first, then wait for them to respawn
        let spawnUntilDeath = SKAction.repeatForever(spawnSequence) // Run the sequqnce forever in the order spawn, waitToSpawn
        self.run(spawnUntilDeath) // Run everything in this function
    }
    
    // Bullet
    func bulletFired() {
        let bullet = SKSpriteNode(imageNamed: "bullet") // Import the bullet image
        bullet.setScale(0.5)
        bullet.position = CGPoint(x: player.position.x, y: player.position.y + player.size.height/1.6) // Setting the bullet so it stays with the player model
        bullet.zPosition = 1 // Behind playermodel but in front of background
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size) // Adds bullet hitbox
        bullet.physicsBody!.affectedByGravity = false // Bool command, bullet is not affected by gravity
        bullet.physicsBody!.categoryBitMask = boxCategories.Bullet // set box category for bullet
        bullet.physicsBody!.collisionBitMask = boxCategories.None // allow bullet to collide with nothing(except enemy)
        bullet.physicsBody!.contactTestBitMask = boxCategories.Enemy // only hit enemy
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
        if currentGameState == gameState.preGame {
            startGame()
        } else if currentGameState == gameState.inGame {
        bulletFired()
        spawnEnemy()
        }
    
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
        if currentGameState == gameState.inGame {
        movePlayer(touchLocation: touchLocation)
        }
    }
    func movePlayer(touchLocation: CGPoint) {
        let destination = CGPoint(x: touchLocation.x, y: player.position.y) // Make player move horizontally
        let actionMove = SKAction.move(to: destination, duration: 0.1)
        player.run(actionMove) // Run the function
        
        if player.position.x > gameArea.maxX { // Making sure player doesn't leave maxX, stops player when hits border
            player.position.x = gameArea.maxX
        }
        if player.position.x < gameArea.minX { // Making sure player doesn't leave minX, stops player when hits border
            player.position.x = gameArea.minX
        }
        
    }
    func spawnEnemy() {
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX) // Random starting X position
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX) // Random ending X position 
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2) // the *1.2 makes it start off screen
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2) // End off screen if it makes it there
        
        // Enemy
        let enemy = SKSpriteNode(imageNamed: "alien ship")
        enemy.setScale(0.2) // Set enemy scale
        enemy.position = startPoint
        self.zPosition = 2 // Will be above the background
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size) // Adds enemy hitbox
        enemy.physicsBody!.affectedByGravity = false // Bool command, enemy is not affected by gravity
        enemy.physicsBody!.categoryBitMask = boxCategories.Enemy
        enemy.physicsBody!.collisionBitMask = boxCategories.None // allow enemy to collide with nothing(except player)
        enemy.physicsBody!.contactTestBitMask = boxCategories.Player | boxCategories.Bullet // Collision with bullets and player
        enemy.name = "enemy"
        self.addChild(enemy) // Add enemy to scene
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 7) // Duration it take to get from top of screen to bottom
        let deleteEnemy = SKAction.removeFromParent() // Delete enemy when off screen because otherwise, game would be laggy
        let loseAlifeAction = SKAction.run(loseLives)
        let enemySequence = SKAction.sequence([moveEnemy,deleteEnemy, loseAlifeAction]) // Combine the two sequences
        if currentGameState == gameState.inGame {
        enemy.run(enemySequence) // Run the sequences
        }
    }
}

