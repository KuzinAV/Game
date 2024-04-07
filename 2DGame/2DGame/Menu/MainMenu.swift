//
//  MainMenu.swift
//  2DGame
//
//  Created by MaxPower on 03.09.2023.
//

import SpriteKit

class MainMenu: SKScene {
    
    //MARK: -Properties
    var backgroundMenu: SKEmitterNode!
    var newGameButton: SKSpriteNode!
    var levelButton: SKSpriteNode!
    var infoButton: SKSpriteNode!
    var labelLevel: SKLabelNode!
    
    //MARK: - Lifecycle
    override func didMove(to view: SKView) {
        backgroundMenu = self.childNode(withName: "background") as? SKEmitterNode
        backgroundMenu.advanceSimulationTime(3)
        
        newGameButton = self.childNode(withName: "newGameButton") as? SKSpriteNode
        
        levelButton = self.childNode(withName: "levelButton") as? SKSpriteNode
        
        labelLevel = self.childNode(withName: "labelLevel") as? SKLabelNode
        
        infoButton = self.childNode(withName: "infoButton") as? SKSpriteNode
        
        let userLevel = UserDefaults.standard
        
        if userLevel.bool(forKey: "hard") {
            labelLevel.text = "Hard"
        } else {
            labelLevel.text = "Easy"
        }
    }
    
    
    //MARK: -Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameButton" {
                let transition = SKTransition.flipVertical(withDuration: 0.5)
                let gameScene = GameScene(size: UIScreen.main.bounds.size)
                self.view?.presentScene(gameScene, transition: transition)
            } else if nodesArray.first?.name == "infoButton" {
                let transition = SKTransition.flipVertical(withDuration: 0.5)
                let info = SKScene(fileNamed: "InfoScene") as? InfoScene
                info?.scaleMode = .aspectFill
                self.view?.presentScene(info!, transition: transition)
            }  else if nodesArray.first?.name == "levelButton" {
                changeLevel()
            }
        }
    }
    
    //MARK: - Helper Methods
    func changeLevel() {
        let userLevel = UserDefaults.standard
        if labelLevel.text == "Easy" {
            labelLevel.text = "Hard"
            userLevel.set(true, forKey: "hard")
        } else {
            labelLevel.text = "Easy"
            userLevel.set(false, forKey: "hard")
        }
    }
}
