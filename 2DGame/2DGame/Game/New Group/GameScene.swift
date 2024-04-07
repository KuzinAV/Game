
import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameTimer: Timer!
    var comets = ["comet1", "comet2", "comet3", "comet4"]
    
    var cometCategory: UInt32 = 0x1 << 1
    var shotCategory: UInt32 = 0x1 << 0
    
    let motionManager = CMMotionManager()
    var xAccelerate: CGFloat = 0
    
    var livesCountLabel: SKLabelNode!
    var livesCount: Int = 3 {
        didSet {
            livesCountLabel.text = "\(livesCount) x \u{2764}\u{FE0F}"
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.size = view.bounds.size
        
        addLives()
        
        starfield = SKEmitterNode(fileNamed: "space")
        starfield.position = CGPoint(x: 200, y: 1472)
        starfield.advanceSimulationTime(3)
        self.addChild(starfield)
        starfield?.zPosition = -1
        
        let shuttleTexture = SKTexture(imageNamed: "shuttle")
        player = SKSpriteNode(texture: shuttleTexture)
        player.setScale(1.75)
        player?.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: 50)
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0) // гравитация
        self.physicsWorld.contactDelegate = self // позволит отслеживать различные соприкосновения
        
        scoreLabel = SKLabelNode(text: "Счет: 0")
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 35
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 85, y: UIScreen.main.bounds.height - 100)
        score = 0
        
        self.addChild(scoreLabel)

        var timeAttack: Double = 1
        
        if UserDefaults.standard.bool(forKey: "hard") {
            timeAttack = 0.2
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: timeAttack, target: self, selector: #selector(addComet), userInfo: nil, repeats: true)
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
            if let accelerometrData = data {
                let acceleration = accelerometrData.acceleration
                self.xAccelerate = CGFloat(acceleration.x) * 0.75 + self.xAccelerate * 0.25
            }
        }
    }
    
    func addLives() {
        livesCountLabel = SKLabelNode(text: "\(livesCount) x \u{2764}\u{FE0F}")
        livesCountLabel.position = CGPoint(x: self.frame.size.width - 70, y: self.frame.size.height - 100)
        livesCountLabel.fontName = "AmericanTypewriter-Bold"
        livesCountLabel.fontSize = 35
        livesCountLabel.fontColor = .white
        self.addChild(livesCountLabel)
    }

    func addNewLife() {
        livesCount += 1
        self.run(SKAction.playSoundFileNamed("newLife", waitForCompletion: false))
    }

    override func didSimulatePhysics() {
        player.position.x += xAccelerate * 50
        
        if player.position.x < 0 {
            player.position = CGPoint(x: UIScreen.main.bounds.width - player.size.width, y: player.position.y)
        } else if player.position.x > UIScreen.main.bounds.width {
            player.position = CGPoint(x: 20, y: player.position.y)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) { // соприкосновение объектов
        var cometBody: SKPhysicsBody
        var shotBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            shotBody = contact.bodyA
            cometBody = contact.bodyB
        } else {
            shotBody = contact.bodyB
            cometBody = contact.bodyA
        }
        
        if (cometBody.categoryBitMask & cometCategory) != 0 && (shotBody.categoryBitMask & shotCategory) != 0 {
            if let shotNode = shotBody.node as? SKSpriteNode, let cometNode = cometBody.node as? SKSpriteNode {
                collisionElements(shotNode: shotNode, cometNode: cometNode)
            }
        }
    }
    
    func collisionElements(shotNode: SKSpriteNode, cometNode: SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "explosionComet")
        explosion?.position = cometNode.position
        self.addChild(explosion!)
        
        self.run(SKAction.playSoundFileNamed("vzriv", waitForCompletion: false))
        
        shotNode.removeFromParent()
        cometNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 0.2)) {
            explosion?.removeFromParent()
        }
        
        score += 5
        if score % 10 == 0 {
            addNewLife()
        }
    }
    
    @objc func addComet() {
        comets = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: comets) as! [String]
        
        let comet = SKSpriteNode(imageNamed: comets[0])
        comet.setScale(0.75)
        let randomPosition = GKRandomDistribution(lowestValue: 20, highestValue: Int(UIScreen.main.bounds.size.width - 20))
        let pos = CGFloat(randomPosition.nextInt())
        comet.position = CGPoint(x: pos, y: UIScreen.main.bounds.size.height + comet.size.height)
        
        comet.physicsBody = SKPhysicsBody(rectangleOf: comet.size)
        comet.physicsBody?.isDynamic = true
        
        comet.physicsBody?.categoryBitMask = cometCategory
        comet.physicsBody?.contactTestBitMask = shotCategory
        comet.physicsBody?.collisionBitMask = 0
        
        self.addChild(comet)
        
        let animDuration: TimeInterval = 6
        
        var actions = [SKAction]()
        
        actions.append(SKAction.move(to: CGPoint(x: pos, y: 0 - comet.size.height), duration: animDuration))
        actions.append(SKAction.run {
            self.run(SKAction.playSoundFileNamed("loss", waitForCompletion: false))
            
            if self.livesCount > 0 {
                    self.livesCount -= 1
                    if self.livesCount == 0 {
                        let transition = SKTransition.crossFade(withDuration: 0.1)
                        if let gameOverScene = GameOverScene(fileNamed: "GameOverScene") {
                            gameOverScene.scaleMode = .aspectFill
                            gameOverScene.score = self.score
                            self.view?.presentScene(gameOverScene, transition: transition)
                        }
                    }
                }
            })

        actions.append(SKAction.removeFromParent())
        
        comet.run(SKAction.sequence(actions))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        shooting()
    }
    
    func shooting() {
        self.run(SKAction.playSoundFileNamed("bullet", waitForCompletion: false))
        
        let shot = SKSpriteNode(imageNamed: "shot")
        shot.position = player.position
        shot.position.y += 5
        
        shot.physicsBody = SKPhysicsBody(circleOfRadius: shot.size.width)
        shot.physicsBody?.isDynamic = true
        shot.setScale(1.25)
        shot.physicsBody?.categoryBitMask = shotCategory
        shot.physicsBody?.contactTestBitMask = cometCategory
        shot.physicsBody?.collisionBitMask = 0
        shot.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(shot)
        
        let animDuration: TimeInterval = 0.3
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: player.position.x, y: UIScreen.main.bounds.size.height + shot.size.height), duration: animDuration))
        actions.append(SKAction.removeFromParent())
        
        shot.run(SKAction.sequence(actions))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
