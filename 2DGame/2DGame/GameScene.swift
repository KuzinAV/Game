
import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKSpriteNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Счет: \(score)"
        }
    }
    
    var gameTimer: Timer!
    var comets = ["comet1", "comet2", "comet3", "comet4"]
    
    var cometCategory: UInt32 = 0x1 << 1
    var shotCategory: UInt32 = 0x1 << 0
    
    let motionManager = CMMotionManager()
    var xAccelerate: CGFloat = 0
    
    override func didMove(to view: SKView) {
        let backgroundTexture = SKTexture(imageNamed: "background")
        starfield = SKSpriteNode (texture: backgroundTexture)
        starfield?.position = CGPoint(x: 0, y: 0)
        self.addChild(starfield)
        starfield?.zPosition = -1
        
        let shuttleTexture = SKTexture(imageNamed: "shuttle")
        player = SKSpriteNode(texture: shuttleTexture)
        player.setScale(3.0)
        player?.position = CGPoint(x: 0, y: -500)
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0) // гравитация
        self.physicsWorld.contactDelegate = self // позволит отслеживать различные соприкосновения
        
        scoreLabel = SKLabelNode(text: "Счет: 0")
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 200, y: 550)
        score = 0
        
        self.addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(addComet), userInfo: nil, repeats: true)
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
            if let accelerometrData = data {
                let acceleration = accelerometrData.acceleration
                self.xAccelerate = CGFloat(acceleration.x) * 0.75 + self.xAccelerate * 0.25
            }
        }
    }
    
    override func didSimulatePhysics() {
        player.position.x += xAccelerate * 50
        
        if player.position.x < -350 {
            player.position = CGPoint(x: 350, y: player.position.y)
        } else if player.position.x > 350 {
            player.position = CGPoint(x: -350, y: player.position.y)
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
            collisionElements(shotNode: shotBody.node as! SKSpriteNode, cometNode: cometBody.node as! SKSpriteNode)
        }
    }
    
    func collisionElements(shotNode: SKSpriteNode, cometNode: SKSpriteNode) {
        //let explosion = SKEmitterNode(fileNamed: "explosion")
        let explosionTexture = SKTexture(imageNamed: "explosion")
        let explosion = SKSpriteNode(texture: explosionTexture)
        explosion.setScale(0.3)
        explosion.position = cometNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("vzriv", waitForCompletion: false))
        
        shotNode.removeFromParent()
        cometNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 0.2)) {
            explosion.removeFromParent()
        }
        
        score += 5
    }
    
    @objc func addComet() {
        comets = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: comets) as! [String]
        
        let comet = SKSpriteNode(imageNamed: comets[0])
        comet.setScale(1.5)
        let randomPosition = GKRandomDistribution(lowestValue: -350, highestValue: 350)
        let pos = CGFloat(randomPosition.nextInt())
        comet.position = CGPoint(x: pos, y: 800)
        
        comet.physicsBody = SKPhysicsBody(rectangleOf: comet.size)
        comet.physicsBody?.isDynamic = true
        comet.physicsBody?.categoryBitMask = cometCategory
        comet.physicsBody?.contactTestBitMask = shotCategory
        comet.physicsBody?.collisionBitMask = 0
        
        self.addChild(comet)
        
        let animDuration: TimeInterval = 6
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: pos, y: -800), duration: animDuration))
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
        shot.setScale(2)
        shot.physicsBody?.categoryBitMask = shotCategory
        shot.physicsBody?.contactTestBitMask = cometCategory
        shot.physicsBody?.collisionBitMask = 0
        shot.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(shot)
        
        let animDuration: TimeInterval = 0.3
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: player.position.x, y: 800), duration: animDuration))
        actions.append(SKAction.removeFromParent())
        
        shot.run(SKAction.sequence(actions))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
