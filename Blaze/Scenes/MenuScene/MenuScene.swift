//
//  MenuScene.swift
//  Snake
//
//  Created by 1 on 06.06.2022.
//

import SpriteKit
import GameplayKit

protocol ControllerDelegate {
    func soundButton(isShow: Bool)
    func showGuide(block: @escaping () -> ())
}

class MenuScene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    var controllerDelegate: ControllerDelegate?
    
    private var startButton: SKSpriteNode {
        let button = SKSpriteNode(imageNamed: "button")
        button.size = CGSize(width: 500, height: 200)
        button.position = CGPoint(x: 0, y: -100)
        return button
    }
    
    private var bestScoreLabel: SKLabelNode {
        let label = SKLabelNode()
        label.fontName = "ArialRoundedMTBold"
        label.fontSize = 100
        label.text = "BEST SCORE: \(Application.shared.bestResult)"
        label.position = CGPoint(x: 0, y: self.frame.height/4)
        return label
    }
    
    private var startLabel: SKLabelNode {
        let label = SKLabelNode()
        label.fontName = "ArialRoundedMTBold"
        label.fontSize = 100
        label.text = "START"
        label.position = CGPoint(x: 0, y: -135)
        label.name = "start"
        return label
    }
    
    override func didMove(to view: SKView) {
        controllerDelegate?.soundButton(isShow: true)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundNode = SKSpriteNode(texture: SKTexture(imageNamed: "background-menu"), size: self.size)
        backgroundNode.zPosition = -1
        addChild(bestScoreLabel)
        addChild(backgroundNode)
        addChild(startButton)
        addChild(startLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if startButton.contains(touch.location(in: self)) {
            let scene = GameScene(size: self.size)
            scene.controllerDelegate = controllerDelegate
            scene.backgroundColor = .clear
            scene.scaleMode = self.scaleMode
            let soundPlayer = SoundPlayer(scene: self)
            soundPlayer.playContact()
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.6)
            self.view?.presentScene(scene, transition: transition)
        }
    }
}
