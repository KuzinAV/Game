//
//  GameOverScene.swift
//  2DGame
//
//  Created by MaxPower on 10.09.2023.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var score: Int = 0
    var scoreLabel: SKLabelNode!
    var newGameButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel.text = "\(score)"
        
        newGameButton = self.childNode(withName: "newGameButton") as? SKSpriteNode
        newGameButton.texture = SKTexture(imageNamed: "play")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let node = self.nodes(at: location)
            
            if node[0].name == "newGameButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
    }
}
