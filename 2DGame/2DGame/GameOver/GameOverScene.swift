//
//  GameOverScene.swift
//  2DGame
//
//  Created by MaxPower on 10.09.2023.
//
import UIKit
import SpriteKit
import AVFoundation

class GameOverScene: SKScene {
    
    var background: SKEmitterNode!
    var explosion: SKEmitterNode!
    
    var score: Int = 0
    var scoreLabel: SKLabelNode!
    var newGameButton: SKSpriteNode!
    var backButton: SKSpriteNode!
    var bestScoreLabel: SKLabelNode!
    
    var gameOverSound: AVAudioPlayer?
    
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
        
        let bestScore = UserDefaults.standard.integer(forKey: "BestScore")

        if score > bestScore {
            UserDefaults.standard.set(score, forKey: "BestScore")
            UserDefaults.standard.synchronize()

        }
        bestScoreLabel = self.childNode(withName: "bestScoreLabel") as? SKLabelNode
        bestScoreLabel.text = "BEST SCORE: \(bestScore)"
        
        let waitAction = SKAction.wait(forDuration: 0.5)
        let playSoundAction = SKAction.run { [weak self] in
            self?.playGameOverSound()
        }
        let sequence = SKAction.sequence([waitAction, playSoundAction])
        self.run(sequence)
    }
    
    func playGameOverSound() {
        let soundURL = Bundle.main.url(forResource: "GameOver", withExtension: "mp3")
        gameOverSound = try? AVAudioPlayer(contentsOf: soundURL!)
        gameOverSound?.prepareToPlay()
        gameOverSound?.play()
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
