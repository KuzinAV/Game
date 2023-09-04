//
//  MainMenu.swift
//  2DGame
//
//  Created by MaxPower on 03.09.2023.
//

import SpriteKit

class MainMenu: SKScene {

    //var backgroundMenu: SKSpriteNode!
    
    var newGameButton: SKSpriteNode!
    var levelButton: SKSpriteNode!
    var labelLevel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        //backgroundMenu = self.childNode(withName: "background") as? SKSpriteNode
 
        newGameButton = self.childNode(withName: "newGameButton") as? SKSpriteNode
        
        levelButton = self.childNode(withName: "levelButton") as? SKSpriteNode
        
        labelLevel = self.childNode(withName: "labelLevel") as? SKLabelNode
        
        let userLevel = UserDefaults.standard
        
        if userLevel.bool(forKey: "hard") {
            labelLevel.text = "Hard"
        } else {
            labelLevel.text = "Easy"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameButton" {
                let transition = SKTransition.flipVertical(withDuration: 0.5)
                let gameScene = GameScene(size: UIScreen.main.bounds.size)
                self.view?.presentScene(gameScene, transition: transition)
            } else if nodesArray.first?.name == "levelButton" {
                changeLevel()
            }
        }
    }
    
    func changeLevel() {
        let userLevel = UserDefaults.standard
        
        if labelLevel.text == "Easy" {
            labelLevel.text = "Hard"
            userLevel.set(true, forKey: "hard")
        } else {
            labelLevel.text = "Easy"
            userLevel.set(false, forKey: "hard")
        }
        
        userLevel.synchronize()
    }
}
