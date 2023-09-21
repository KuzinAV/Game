//
//  GameOverScene.swift
//  2DGame
//
//  Created by MaxPower on 10.09.2023.
//
import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var background: SKEmitterNode!
    var explosion: SKEmitterNode!
    
    
    var score: Int = 0
    var scoreLabel: SKLabelNode!
    var newGameButton: SKSpriteNode!
    var backButton: SKSpriteNode!
    var bestScoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        background = self.childNode(withName: "background") as? SKEmitterNode
        background.advanceSimulationTime(3)
        
        explosion = self.childNode(withName: "explosion") as? SKEmitterNode
        explosion.advanceSimulationTime(0.9)
        
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel.text = "YOU SCORE: \(score)"
        
        newGameButton = self.childNode(withName: "newGameButton") as? SKSpriteNode
        newGameButton.texture = SKTexture(imageNamed: "play")
        
        backButton = self.childNode(withName: "backButton") as? SKSpriteNode
        
        // Загрузка лучшего результата из UserDefaults
        let bestScore = UserDefaults.standard.integer(forKey: "BestScore")

        // Проверка, является ли текущий результат лучшим
        if score > bestScore {
            // Сохранение нового лучшего результата в UserDefaults
            UserDefaults.standard.set(score, forKey: "BestScore")
            UserDefaults.standard.synchronize()

        }
        bestScoreLabel = self.childNode(withName: "bestScoreLabel") as? SKLabelNode
        bestScoreLabel.text = "BEST SCORE: \(bestScore)"
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
            
            if node[0].name == "backButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                if let mainMenu = MainMenu(fileNamed: "MainMenu") {
                    mainMenu.scaleMode = .aspectFill
                    self.view?.presentScene(mainMenu, transition: transition)
                }
            }
        }
    }
}

