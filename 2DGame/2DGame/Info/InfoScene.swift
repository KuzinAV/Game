//
//  InfoScene.swift
//  2DGame
//
//  Created by MaxPower on 21.09.2023.
//

import UIKit
import SpriteKit
import AVFoundation

class InfoScene: SKScene {
    
    //MARK: -Properties
    var infoBackground: SKEmitterNode!
    var backButton: SKSpriteNode!
    var infoLabel: SKLabelNode!
    var backgroundSound: AVAudioPlayer?
    
    
    //MARK: -Lifecycle Methods
    override func didMove(to view: SKView) {
        let soundURL = Bundle.main.url(forResource: "InfoBackground", withExtension: "mp3")
        backgroundSound = try? AVAudioPlayer(contentsOf: soundURL!)
        backgroundSound?.prepareToPlay()
        backgroundSound?.play()
        
        infoBackground = self.childNode(withName: "infoBackground") as? SKEmitterNode
        infoBackground.advanceSimulationTime(3)
        
        backButton = self.childNode(withName: "backButton") as? SKSpriteNode
        
        infoLabel = self.childNode(withName: "infoLabel") as? SKLabelNode
        infoLabel.text = "Thank you, dear friend, for downloading this game.It was my graduation project, and I hopeit brought you more joy than it tested my nerves.I want to express special thanks for your mentorship Darya Astapava and Roman Kniukh"
        infoLabel.preferredMaxLayoutWidth = self.frame.size.width * 0.9
        infoLabel.horizontalAlignmentMode = .center
        let constraintX = SKConstraint.positionX(SKRange(constantValue: 375))
        let constraintY = SKConstraint.positionY(SKRange(constantValue: 700))
        infoLabel.constraints = [constraintX, constraintY]
    }
    
    //MARK: -Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let node = self.nodes(at: location)
            
            if node[0].name == "backButton" {
                let transition = SKTransition.flipVertical(withDuration: 0.5)
                if let mainMenu = MainMenu(fileNamed: "MainMenu") {
                    mainMenu.scaleMode = .aspectFill
                    self.view?.presentScene(mainMenu, transition: transition)
                }
            }
        }
    }
}
