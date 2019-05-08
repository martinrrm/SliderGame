//  GameOverScene.swift
//  Created by Cristian Acosta on 3/28/19.
//  Copyright © 2019 Cristian Acosta. All rights reserved.

/*
 CHANGE touchesBegan TO GO BACK TO MAIN GAME INSTEAD OF RESTARTING MINI GAME
 */

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    // RESTART LABEL (GLOBAL)
    let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    override func didMove(to view: SKView) {
        // BACKGROUND SETUP
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        // GAMEOVER LABEL SETUP
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 150
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        // SCORE LABEL SETUP
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        // RESTART LABEL SETUP
        restartLabel.text = "Go Back"
        restartLabel.fontSize = 100
        restartLabel.fontColor = SKColor.green
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        self.addChild(restartLabel)
    }
    
    // RESTART WHEN RESTART LABEL IS TAPPED
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if(gameScore < 10){
                restartLabel.text = "Game Over"
            }
            else if restartLabel.contains(pointOfTouch){
                self.view!.window!.rootViewController!.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
