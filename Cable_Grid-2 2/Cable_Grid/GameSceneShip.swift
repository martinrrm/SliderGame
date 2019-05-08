//  GameScene.swift
//  Created by Cristian Acosta on 3/23/19.
//  Copyright © 2019 Cristian Acosta. All rights reserved.

import SpriteKit
import GameplayKit

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // SCORE LABEL (GLOBAL)
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    // CURRENT LEVEL (GLOBAL)
    var levelNumber = 0
    
    // LIVES LABEL (GLOBAL)
    var livesNumber = 5
    let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    // INSTRUCTIONS LABELS (GLOBAL)
    let instructionLabel1 = SKLabelNode(fontNamed: "The Bold Font")
    let instructionLabel2 = SKLabelNode(fontNamed: "The Bold Font")
    
    // GLOBAL OBJECTS
    let player = SKSpriteNode(imageNamed: "shuttle")
    let bulletSound = SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    // START LABEL (GLOBAL)
    let startLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    // GAME STATES (START IN PREGAME)
    enum gameState{
        case preGame // before the game starts
        case inGame // during the game
        case afterGame // after game ends
    }
    var currentGameState = gameState.preGame
    
    // COLLISION SYSTEM
    struct physicsCategories {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 // binary 1
        static let Bullet : UInt32 = 0b10 // binary 2
        static let Enemy : UInt32 = 0b100 // binary 4
    }
    
    // RANDOM SPAWN GENERATOR
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    // PLAYABLE SCREEN ZONE
    let gameArea: CGRect
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // LOAD SCENE
    override func didMove(to view: SKView) {
        // SCORE INITIALIZATION
        gameScore = 0
        self.physicsWorld.contactDelegate = self
        
        // BACKGROUND SETUP
        for i in 0...1{
            let background = SKSpriteNode(imageNamed: "background")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
        }
        
        // PLAYER SETUP
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = physicsCategories.Player
        player.physicsBody!.collisionBitMask = physicsCategories.None
        player.physicsBody!.contactTestBitMask = physicsCategories.Enemy
        self.addChild(player)
        
        // SOCRE LABEL SETUP
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        if UIDevice.current.name == "iPhone X" || UIDevice.current.name == "iPhone Xs" ||
            UIDevice.current.name == "iPhone Xs Max" || UIDevice.current.name == "iPhone Xʀ" {
            scoreLabel.position = CGPoint(x: self.size.width*0.20, y: self.size.height*0.93)
        }
        else{
            scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height*0.95)
        }
        scoreLabel.zPosition = 100
        scoreLabel.alpha = 0
        self.addChild(scoreLabel)
        
        
        // LIVES LABEL SETUP
        livesLabel.text = "Lives: 5"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        if UIDevice.current.name == "iPhone X" || UIDevice.current.name == "iPhone Xs" ||
            UIDevice.current.name == "iPhone Xs Max" || UIDevice.current.name == "iPhone Xʀ" {
            livesLabel.position = CGPoint(x: self.size.width*0.80, y: self.size.height*0.93)
        }
        else{
            livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height*0.95)
        }
        livesLabel.zPosition = 100
        livesLabel.alpha = 0
        self.addChild(livesLabel)
        
        // START LABEL SETUP
        startLabel.text = "Tap to begin"
        startLabel.fontSize = 100
        startLabel.fontColor = SKColor.white
        startLabel.zPosition = 1
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        startLabel.alpha = 0
        self.addChild(startLabel)
        
        // INSTRUCTIONS SETUP
        instructionLabel1.text = "drag ship left and right"
        instructionLabel1.fontSize = 70
        instructionLabel1.fontColor = SKColor.white
        instructionLabel1.zPosition = 1
        instructionLabel1.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.35)
        instructionLabel1.alpha = 0
        self.addChild(instructionLabel1)
        
        instructionLabel2.text = "tap to shoot"
        instructionLabel2.fontSize = 70
        instructionLabel2.fontColor = SKColor.white
        instructionLabel2.zPosition = 1
        instructionLabel2.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.3)
        instructionLabel2.alpha = 0
        self.addChild(instructionLabel2)
        
        // FADE IN EFFECT
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        scoreLabel.run(fadeInAction)
        livesLabel.run(fadeInAction)
        startLabel.run(fadeInAction)
        instructionLabel1.run(fadeInAction)
        instructionLabel2.run(fadeInAction)
    }
    
    // BACKGROUND MOVEMENT
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    let amountToMove: CGFloat = 600.0
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        }
        else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        let amountToMoveBackground = amountToMove * CGFloat(deltaFrameTime)
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            if self.currentGameState == gameState.inGame{
                background.position.y -= amountToMoveBackground
            }
            if background.position.y < -self.size.height{
                background.position.y += self.size.height*2
            }
        }
    }
    
    // START GAME
    func startGame(){
        // CHANGE GAME STATE
        currentGameState = gameState.inGame
        
        // REMOVE START LABEL
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        startLabel.run(deleteSequence)
        instructionLabel1.run(deleteSequence)
        instructionLabel2.run(deleteSequence)
        
        // MOVE PLAYER SHIP INTO FRAME
        let moveShip = SKAction.moveTo(y: self.size.height*0.1, duration: 0.5)
        
        // START NEW LEVEL
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShip, startLevelAction])
        player.run(startGameSequence)
    }
    
    // LIVES SYSTEM
    func loseALife(){
        // UPDATE LIVES ON HIT OR MISS (I guess they never miss, huh?)
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        if livesNumber == 1 {
            livesLabel.fontColor = SKColor.red
        }
        
        // LIVES LABEL ANIMATION
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        // LIVES DEPLETED (GAME OVER)
        if livesNumber == 0 {
            runGameOver()
        }
    }
    
    // SCORING SYSTEM
    func addScore() {
        // UPDATE SCORE ON HIT
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        // ADVANCE TO LEVEL 1
        if gameScore == 10 {
            scoreLabel.fontColor = SKColor.green
        }
        // ADVANCE TO LEVEL 2
        if gameScore == 25 {
            scoreLabel.fontColor = SKColor.yellow
        }
        // ADVANCE TO LEVEL 3
        if gameScore == 50 {
            scoreLabel.fontColor = SKColor.orange
        }
        // UPDATE LEVEL
        if gameScore == 10 || gameScore == 25 || gameScore == 50{
            startNewLevel()
        }
    }
    
    // GAME OVER
    func runGameOver(){
        // UPDATE GAME STATE
        currentGameState = gameState.afterGame
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            enemy.removeAllActions()
        }
        
        
        // CHANGE SCENE PREPARATION
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    // CHANGE SCENE ON GAME OVER
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    // COLLISION DETECTION
    func didBegin(_ contact: SKPhysicsContact) {
        // OBJECT VESSELS
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        // DETECT CONTACT
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        // ENEMY HITS PLAYER
        if body1.categoryBitMask == physicsCategories.Player && body2.categoryBitMask == physicsCategories.Enemy {
            // SPAWN EXPLOSIONS
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            // REMOVE OBJETCTS
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            // GAME OVER
            runGameOver()
        }
        // BULLET HITS ENEMY
        if body1.categoryBitMask == physicsCategories.Bullet && body2.categoryBitMask == physicsCategories.Enemy {
            if body2.node != nil{
                if body2.node!.position.y > self.size.height {
                    return // if the enemy is off the screen, do nothing
                }
                else {
                    addScore() // UPDATE SCORE
                    spawnExplosion(spawnPosition: body2.node!.position) // SPAWN EXPLOSION
                }
            }
            // DELETE OBJECTS
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
    }
    
    // EXPLOSION SPAWNING
    func spawnExplosion(spawnPosition: CGPoint) {
        // EXPLOSION SETUP
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        // EXPLOSION ANIMATION SETUP
        let scaleIn = SKAction.scale(to: 1, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
    }
    
    // LEVELING SYSTEM
    func startNewLevel() {
        // INCREASE LEVEL
        levelNumber += 1
        
        // WAIT BEFORE SPAWNING ENEMIES
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        // SPAWNING FREQUENCY FOR EACH LEVEL
        switch levelNumber {
        case 1: levelDuration = 2
        case 2: levelDuration = 1.5
        case 3: levelDuration = 1
        case 4: levelDuration = 0.5
        default:
            levelDuration = 2
            print("cannot find level info")
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
    }
    
    // FIRING SYSTEM
    func fireBullet() {
        // BULLET SETUP
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = physicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = physicsCategories.None
        bullet.physicsBody!.contactTestBitMask = physicsCategories.Enemy
        self.addChild(bullet)
        
        // BULLET ANIMATION SETUP
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    // ENEMY SPAWNING SYSTEM
    func spawnEnemy() {
        // RANDOM TRAJECTORY
        let XStart = random(min: gameArea.minX, max: gameArea.maxX)
        let XEnd = random(min: gameArea.minX, max: gameArea.maxX)
        let startPoint = CGPoint(x: XStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: XEnd, y: -self.size.height * 0.2)
        
        // ENEMY SETUP
        let enemy = SKSpriteNode(imageNamed: "asteroid")
        enemy.name = "Enemy"
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = physicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = physicsCategories.None
        enemy.physicsBody!.contactTestBitMask = physicsCategories.Player | physicsCategories.Bullet
        self.addChild(enemy)
        
        // ENEMY ANIMATION SETUP
        let moveEnemy = SKAction.move(to: endPoint, duration: 2)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        
        // ONLY SPAWN ENEMIES WHILE IN GAME
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
        }
        
        // ADJUST ENEMY SPRITE TO TRAJECTORY
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let rotate = atan2(dy, dx)
        enemy.zRotation = rotate
        
    }
    
    // FIRE ON TOUCH
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // START GAME IF ON PREGAME
        if currentGameState == gameState.preGame{
            startGame()
        }
            // FIRE IF IN GAME
        else if currentGameState == gameState.inGame{
            fireBullet()
        }
    }
    
    // PLAYER MOVEMENT
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousTouch.x
            if currentGameState == gameState.inGame{
                player.position.x += amountDragged
            }
            if player.position.x > gameArea.maxX - player.size.width/2 {
                player.position.x = gameArea.maxX - player.size.width/2
            }
            if player.position.x < gameArea.minX + player.size.width/2 {
                player.position.x = gameArea.minX + player.size.width/2
            }
        }
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}
