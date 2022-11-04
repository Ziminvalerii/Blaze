//
//  GameScene.swift
//  Snake
//
//  Created by 1 on 01.06.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var snakeBody: [SKSpriteNode] = []
    private var soundPlayer: SoundPlayer?
    private var snakeHead = SnakeBody()
    private var target = Target()
    private let cameraNode = SKCameraNode()
    private var leftBorder = Border()
    private var rightBorder = Border()
    private var backgroundNode: SKSpriteNode!
    private var backNode: SKSpriteNode!
    private var currentTextureType: TextureType = TextureType.allCases.randomElement()!
    private var nextBarrierYPosition: CGFloat = 0
    private var barrierSize: CGFloat = 0
    var controllerDelegate: ControllerDelegate?
    
    lazy var scoreLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.zPosition = 5
        label.position = CGPoint(x: 0, y: self.frame.height/2)
        label.fontName = "ArialRoundedMTBold"
        label.fontSize = 100
        label.text = "SCORE: \(score)"
        return label
    }()
    
    private var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        configureScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if backNode.contains(touch.location(in: self)) {
            let scene = MenuScene(size: self.size)
            scene.controllerDelegate = controllerDelegate
            scene.scaleMode = self.scaleMode
            let soundPlayer = SoundPlayer(scene: self)
            soundPlayer.playLose()
            let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.6)
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if self.contains(location) {
                snakeHead.run(SKAction.moveTo(x: location.x, duration: 0.05))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        cameraNode.position.y = snakeHead.position.y + self.size.height / 8
        scoreLabel.position.y = cameraNode.position.y + self.size.height/2.7
        backNode.position.y = cameraNode.position.y + self.size.height/2.6
        leftBorder.position.y = cameraNode.position.y
        rightBorder.position.y = cameraNode.position.y
        backgroundNode.position.y = cameraNode.position.y
    }
    
    private func configureScene() {
        controllerDelegate?.soundButton(isShow: false)
        backgroundNode = SKSpriteNode(texture: SKTexture(imageNamed: "background"), size: self.size)
        backgroundNode.name = "background"
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
        backNode = SKSpriteNode(texture: SKTexture(imageNamed: "back"), size: CGSize(width: 50, height: 70))
        backNode.zPosition = 5
        backNode.position.x = -self.size.width/2 + 25 + backNode.size.width/2
        addChild(backNode)
        
        createSnake()
        addChild(scoreLabel)
        nextBarrierYPosition = snakeHead.position.y + 2000
        
        cameraNode.position = CGPoint(x: 0, y: snakeHead.position.y - size.height / 3)
        addChild(cameraNode)
        camera = cameraNode

        soundPlayer = SoundPlayer(scene: self)
        configureBorders()
        
        for i in 0..<4 {
            createBarriers()
            let position = CGPoint(x: 0, y: Int(snakeHead.position.y) + ((i + 1) * 300))
            guard let texture = TextureType.allCases.randomElement() else { return }
            let target = Target(texture: texture.snakeTexture, size: CGSize(width: 60, height: 60))
            target.position = position
            target.configureNode()
            target.targetTexture = texture
            addChild(target)
        }
        startGame()
    }
    
    private func startGame() {
        let move = SKAction.repeatForever(SKAction.moveTo(y: 500000, duration: 800))
        if Application.shared.isInitializedApp {
            snakeHead.run(move, withKey: "move")
        } else {
            controllerDelegate?.showGuide(block: { 
                self.snakeHead.run(move, withKey: "move")
                Application.shared.isInitializedApp = true
            })
        }
    }
    
    private func setSpeed() {
        snakeHead.removeAction(forKey: "move")
        let baseDuration: CGFloat = 800
        let duration = baseDuration - CGFloat(snakeBody.count * 20)
        let move = SKAction.repeatForever(SKAction.moveTo(y: 500000, duration: duration > baseDuration ? baseDuration : duration))
        snakeHead.run(move, withKey: "move")
    }
    
    private func configureBorders() {
        leftBorder = Border(rectOf: CGSize(width: 10, height: self.size.height))
        leftBorder.position.x = -self.size.width/2
        leftBorder.fillColor = .clear
        leftBorder.strokeColor = .clear
        leftBorder.configureNode(size: leftBorder.frame.size)
        addChild(leftBorder)
        rightBorder = Border(rectOf: CGSize(width: 10, height: self.size.height))
        rightBorder.position.x = self.size.width/2
        rightBorder.fillColor = .clear
        rightBorder.strokeColor = .clear
        rightBorder.configureNode(size: rightBorder.frame.size)
        addChild(rightBorder)
    }
    
    private func createBarriers() {
        let textureArray = TextureType.allCases.shuffled()
        let barriersCount = TextureType.allCases.count
        let spacing = (25 * CGFloat(barriersCount)) / CGFloat(barriersCount + 1)
        barrierSize = self.size.width / CGFloat(barriersCount) - 25
        for i in 0..<barriersCount {
            let xPosition: CGFloat = ((CGFloat(i) * barrierSize) - self.size.width / 2) + ((CGFloat(i + 1) * spacing))
            let texture = textureArray[i]
            let barrier = Barrier(texture: texture.barrierTexture, size: CGSize(width: barrierSize, height: barrierSize))
            barrier.barrierTexture = texture
            barrier.configureNode()
            barrier.position = CGPoint(x: xPosition + barrier.size.width/2, y: nextBarrierYPosition)
            addChild(barrier)
        }
        nextBarrierYPosition += 1000
    }
    
    private func createBarrierBorders(size: CGSize, position: CGPoint) {
        let border = Border(rectOf: size)
        border.configureNode(size: size)
        border.position = position
        border.fillColor = .red
        border.strokeColor = .red
        addChild(border)
    }
    
    private func createSnake() {
        snakeBody.removeAll()
        let body = SnakeBody(texture: currentTextureType.snakeTexture, size: CGSize(width: 60, height: 60))
        body.position = CGPoint(x: 0, y: 0)
        addChild(body)
        snakeBody.append(body)
        score = 1
        if let snakeHead = snakeBody.first as? SnakeBody {
            self.snakeHead = snakeHead
            snakeHead.configureSnakeHead()
        }
    }
    
    private func createTarget() {
        guard let texture = TextureType.allCases.randomElement(), self.target.position.y < snakeHead.position.y else { return }
        let target = Target(texture: texture.snakeTexture, size: CGSize(width: 60, height: 60))
        target.position = CGPoint(x: random(-self.size.width/2+100, self.size.width/2-100), y: random(snakeHead.position.y + snakeHead.frame.height + barrierSize, snakeHead.position.y + 1000 - barrierSize))
        target.configureNode()
        target.targetTexture = texture
        self.target = target
        addChild(target)
    }
    
    private func addBody() {
        let body = SnakeBody(texture: currentTextureType.snakeTexture, size: CGSize(width: 60, height: 60))
        body.position = CGPoint(x: snakeBody[snakeBody.count - 1].position.x, y: snakeBody[snakeBody.count - 1].position.y - snakeBody[snakeBody.count - 1].frame.size.height)
        snakeBody.append(body)
        addChild(body)
        for node in snakeBody {
            if let body = node as? SnakeBody {
                body.texture = currentTextureType.snakeTexture
            }
        }
        setNodeConstraint(nodeA: snakeBody[snakeBody.count - 2], nodeB: snakeBody.last!)
        if snakeBody.count > score {
            score = snakeBody.count
        }
    }
    
    private func setNodeConstraint(nodeA: SKSpriteNode, nodeB: SKSpriteNode) {
        let rangeToNode = SKRange(lowerLimit: 60, upperLimit: 60)
        let distanceConstraint = SKConstraint.distance(rangeToNode, to: nodeA)
        let rangeOrientation = SKRange(lowerLimit: CGFloat(Double.pi/2), upperLimit: CGFloat(Double.pi/2))
        let orientConstraint = SKConstraint.orient(to: nodeA, offset: rangeOrientation)
        nodeB.constraints = [distanceConstraint, orientConstraint]
    }
    
    private func breakBarrierParticles(barrierTexture: TextureType, position: CGPoint? = nil) {
        if let particles = SKEmitterNode(fileNamed: "BreakBarrier") {
            particles.position = position ?? CGPoint(x: snakeHead.position.x, y: snakeHead.position.y)
            particles.particleTexture = barrierTexture.barrierTexture
            particles.particleColorBlendFactor = 1
            particles.particleColorSequence = nil
            particles.particleColor = currentTextureType.color
            addChild(particles)
            
            let removeAction = SKAction.sequence([
                SKAction.wait(forDuration: 2),
                SKAction.removeFromParent()
            ])
            
            particles.run(removeAction)
        }
    }
    
    private func breakSnakeTailParticles(targetTexture: TextureType? = nil, position: CGPoint? = nil) {
        if let particles = SKEmitterNode(fileNamed: "BreakSnake") {
            let snakeTail = snakeBody.count > 2 ? snakeBody[snakeBody.count-2] : snakeHead
            particles.position = position ?? CGPoint(x: snakeTail.position.x, y: snakeTail.position.y)
            particles.particleTexture = targetTexture?.snakeTexture ?? currentTextureType.snakeTexture
            particles.particleColorBlendFactor = 1
            particles.particleColorSequence = nil
            particles.particleColor = targetTexture?.color ?? currentTextureType.color
            addChild(particles)
            
            let removeAction = SKAction.sequence([
                SKAction.wait(forDuration: 2),
                SKAction.removeFromParent()
            ])
            
            particles.run(removeAction)
        }
    }
    
    private func gameOver() {
        let scene = GameOverScene(size: self.size)
        scene.controllerDelegate = controllerDelegate
        scene.backgroundColor = .clear
        scene.score = score
        scene.scaleMode = self.scaleMode
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.6)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view?.presentScene(scene, transition: transition)
            self.removeAllActions()
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if hasContact(contact: contact, categoryA: BodyType.snakeHead.rawValue, categoryB: BodyType.target.rawValue) {
            let target: Target = getNode(contact: contact)
            currentTextureType = target.targetTexture
            target.removeFromParent()
            addBody()
            soundPlayer?.playTarget()
        }
        else if hasContact(contact: contact, categoryA: BodyType.snakeHead.rawValue, categoryB: BodyType.barrier.rawValue) {
            createBarriers()
            createTarget()
            setSpeed()
            let barrier: Barrier = getNode(contact: contact)
            if barrier.barrierTexture == currentTextureType {
                breakBarrierParticles(barrierTexture: barrier.barrierTexture)
                soundPlayer?.playContact()
            } else {
                soundPlayer?.playFailContact()
                if snakeBody.count == 1 {
                    for node in children {
                        if let barrier = node as? Barrier {
                            breakBarrierParticles(barrierTexture: barrier.barrierTexture, position: barrier.position)
                            barrier.removeFromParent()
                        }
                        else if let target = node as? Target {
                            breakSnakeTailParticles(targetTexture: target.targetTexture, position: target.position)
                            target.removeFromParent()
                        }
                    }
                    gameOver()
                }
                breakSnakeTailParticles()
                if let snakeTail = snakeBody.last {
                    snakeTail.removeFromParent()
                    snakeBody.removeLast()
                }
            }
            barrier.removeFromParent()
            barrier.breakBarrier()
        }
    }
    
    private func hasContact(contact: SKPhysicsContact, categoryA: UInt32, categoryB: UInt32) -> Bool {
        let bodyA : SKPhysicsBody = contact.bodyA
        let bodyB : SKPhysicsBody = contact.bodyB
        if (bodyA.categoryBitMask == categoryA && bodyB.categoryBitMask == categoryB) {
            return true
        }
        if (bodyA.categoryBitMask == categoryB && bodyB.categoryBitMask == categoryA) {
            return true
        }
        return false
    }
    
    private func getNode<T>(contact: SKPhysicsContact) -> T {
        if let component = contact.bodyA.node as? T {
            return component
        }
        if let component = contact.bodyB.node as? T  {
            return component
        }
        fatalError()
    }
}
