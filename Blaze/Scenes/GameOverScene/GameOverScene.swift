//
//  GameOverScene.swift
//  Snake
//
//  Created by 1 on 06.06.2022.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    
    var controllerDelegate: ControllerDelegate?
    var score = 0
    private var backgroundNode: SKSpriteNode!
    private var timer: Timer?
    private var soundPlayer: SoundPlayer!
    
    private lazy var button: SKSpriteNode = {
        let button = SKSpriteNode(imageNamed: "button")
        button.size = CGSize(width: 500, height: 200)
        button.position = CGPoint(x: -120, y: 0)
        let label = SKLabelNode()
        label.fontName = "ArialRoundedMTBold"
        label.fontSize = 100
        label.text = "AGAIN"
        label.position = CGPoint(x: 0, y: -35)
        button.addChild(label)
        return button
    }()
    
    private lazy var homeButton: SKSpriteNode = {
        let button = SKSpriteNode(imageNamed: "button-home")
        button.position = CGPoint(x: 280, y: 0)
        return button
    }()
    
    private lazy var statusLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "ArialRoundedMTBold"
        label.fontSize = 140
        label.fontColor = .yellow
        label.text = "NEW RECORD!"
        label.position = CGPoint(x: 0, y: self.frame.height/4)
        return label
    }()
    
    private lazy var scoreLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "ArialRoundedMTBold"
        label.fontSize = 100
        label.text = "YOUR SCORE: \(score)"
        label.position = CGPoint(x: 0, y: self.frame.height/4 - 200)
        return label
    }()
    
    private var againLabel: SKLabelNode {
        let label = SKLabelNode()
        label.fontName = "ArialRoundedMTBold"
        label.fontSize = 100
        label.text = "AGAIN"
        label.position = CGPoint(x: 0, y: -35)
        return label
    }
    
    override func didMove(to view: SKView) {
        
        configureScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if button.contains(touch.location(in: self)) {
            let scene = GameScene(size: self.size)
            scene.controllerDelegate = controllerDelegate
            scene.backgroundColor = .clear
            scene.scaleMode = self.scaleMode
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.6)
            self.view?.presentScene(scene, transition: transition)
            soundPlayer.playContact()
            timer?.invalidate()
        }
        else if homeButton.contains(touch.location(in: self)) {
            let scene = MenuScene(size: self.size)
            scene.controllerDelegate = controllerDelegate
            scene.scaleMode = self.scaleMode
            let transition = SKTransition.flipVertical(withDuration: 0.6)
            self.view?.presentScene(scene, transition: transition)
            soundPlayer.playContact()
            timer?.invalidate()
        }
    }
    
    private func configureScene() {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        soundPlayer = SoundPlayer(scene: self)
        statusLabel.text = score > Application.shared.bestResult ? "NEW RECORD!" : "YOU LOSE"
        addChild(statusLabel)
        scoreLabel.text = score > Application.shared.bestResult ? "BEST SCORE: \(score)" : "YOUR SCORE: \(score)"
        addChild(scoreLabel)
        let backgroundTexture = SKTexture(imageNamed: score > Application.shared.bestResult ? "background-win" : "background")
        backgroundNode = SKSpriteNode(texture: backgroundTexture, size: self.size)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        if score > Application.shared.bestResult {
            Application.shared.bestResult = score
            timer = .scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(winParticles), userInfo: nil, repeats: true)
            soundPlayer.playWin()
        } else {
            soundPlayer.playLose()
        }
        addChild(button)
        addChild(homeButton)
    }
    
    @objc private func winParticles() {
        if let particles = SKEmitterNode(fileNamed: "BreakBarrier") {
            particles.position = CGPoint(x: random(-self.size.width/2, self.size.width/2), y: random(-self.size.height/2, self.size.height/2))
            let randomTexture = TextureType.allCases.randomElement()
            particles.particleTexture = randomTexture?.barrierTexture
            particles.particleColorBlendFactor = 1
            particles.particleColorSequence = nil
            particles.particleColor = randomTexture?.color ?? .orange
            addChild(particles)
            
            let removeAction = SKAction.sequence([
                SKAction.wait(forDuration: 2),
                SKAction.removeFromParent()
            ])
            
            particles.run(removeAction)
        }
    }
}

