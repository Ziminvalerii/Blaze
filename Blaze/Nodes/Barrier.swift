//
//  Barrier.swift
//  Snake
//
//  Created by 1 on 01.06.2022.
//

import SpriteKit

class Barrier: SKSpriteNode {
    
    var barrierTexture: TextureType = .purple
    
    func configureNode() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.pinned = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = BodyType.barrier.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.snakeHead.rawValue
    }
    
    func breakBarrier() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
