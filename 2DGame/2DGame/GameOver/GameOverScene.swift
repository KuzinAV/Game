//
//  GameOverScene.swift
//  2DGame
//
//  Created by MaxPower on 10.09.2023.
//
/*
import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var background: SKEmitterNode!
    
    var score: Int = 0
    var scoreLabel: SKLabelNode!
    var newGameButton: SKSpriteNode!
    var name1: SKLabelNode!
    var name2: SKLabelNode!
    var name3: SKLabelNode!
    var name4: SKLabelNode!
    var name5: SKLabelNode!
    var score1: SKLabelNode!
    var score2: SKLabelNode!
    var score3: SKLabelNode!
    var score4: SKLabelNode!
    var score5: SKLabelNode!
    
    
    override func didMove(to view: SKView) {
        background = self.childNode(withName: "background") as? SKEmitterNode
        background.advanceSimulationTime(3)
        
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
*/
/*
import UIKit
import SpriteKit

struct Player {
    let name: String
    let score: Int
}

class GameOverScene: SKScene, UITextFieldDelegate {
    var background: SKEmitterNode!
    var score: Int = 0
    var scoreLabel: SKLabelNode!
    var newGameButton: SKSpriteNode!
    var score1: SKLabelNode?
    var score2: SKLabelNode?
    var score3: SKLabelNode?
    var score4: SKLabelNode?
    var score5: SKLabelNode?
    var players: [Player] = []
    
    var submitButton: UIButton! // Объявляем submitButton как свойство класса
    
    override func didMove(to view: SKView) {
        background = self.childNode(withName: "background") as? SKEmitterNode
        background.advanceSimulationTime(3)
        
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel.text = "\(score)"
        
        newGameButton = self.childNode(withName: "newGameButton") as? SKSpriteNode
        newGameButton.texture = SKTexture(imageNamed: "play")
        
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        textField.center = CGPoint(x: 200, y: 350)
        textField.placeholder = "Введите ваше имя"
        textField.borderStyle = .roundedRect
        self.view?.addSubview(textField)
        
        submitButton = UIButton(type: .system)
        submitButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        submitButton.center = CGPoint(x: 200, y: 400)
        submitButton.setTitle("Отправить", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        self.view?.addSubview(submitButton)
        
        score1 = self.childNode(withName: "score1") as? SKLabelNode
        score2 = self.childNode(withName: "score2") as? SKLabelNode
        score3 = self.childNode(withName: "score3") as? SKLabelNode
        score4 = self.childNode(withName: "score4") as? SKLabelNode
        score5 = self.childNode(withName: "score5") as? SKLabelNode
        
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
    
    @objc func submitButtonTapped() {
        guard let textField = self.view?.subviews.first(where: { $0 is UITextField }) as? UITextField,
              let playerName = textField.text,
              !playerName.isEmpty else {
            return
        }
        
        let playerScore = score
        let player = Player(name: playerName, score: playerScore)
        players.append(player)
        players.sort { $0.score > $1.score }
        
        score1?.text = players.count >= 1 ? "\(players[0].name): \(players[0].score)" : ""
        score2?.text = players.count >= 2 ? "\(players[1].name): \(players[1].score)" : ""
        score3?.text = players.count >= 3 ? "\(players[2].name): \(players[2].score)" : ""
        score4?.text = players.count >= 4 ? "\(players[3].name): \(players[3].score)" : ""
        score5?.text = players.count >= 5 ? "\(players[4].name): \(players[4].score)" : ""
        
        textField.removeFromSuperview()
        submitButton.removeFromSuperview()
    }
}
*/

/*
import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var background: SKEmitterNode!
    
    var score: Int = 0
    var scoreLabel: SKLabelNode!
    var newGameButton: SKSpriteNode!
    var name1: SKLabelNode!
    
    // Массив для хранения результатов
    var leaderboard: [Int] = []
    
    override func didMove(to view: SKView) {
        background = self.childNode(withName: "background") as? SKEmitterNode
        background.advanceSimulationTime(3)
        
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel.text = "\(score)"
        
        newGameButton = self.childNode(withName: "newGameButton") as? SKSpriteNode
        newGameButton.texture = SKTexture(imageNamed: "play")
        
        name1 = self.childNode(withName: "name1") as? SKLabelNode
        name1.fontName = "AmericanTypewriter-Bold"
        name1.fontSize = 35
        name1.fontColor = .white
        
        // Добавляем текущий результат в таблицу лидеров
        leaderboard.append(score)
        
        // Сортируем таблицу лидеров по убыванию очков
        leaderboard.sort { $0 > $1 }
        
        // Отображаем таблицу лидеров в метке name1
        updateLeaderboard()
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
    
    func updateLeaderboard() {
        name1.text = ""
        
        let maxScoresToShow = min(5, leaderboard.count)
        for index in (leaderboard.count - maxScoresToShow)..<leaderboard.count {
            let score = leaderboard[index]
            name1.text! += "\(index+1). \(score)\n"
        }
        
        name1.numberOfLines = maxScoresToShow
        name1.fontColor = .white
        name1.fontSize = 45
        name1.fontName = "AmericanTypewriter-Bold"
    }
}
*/

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

