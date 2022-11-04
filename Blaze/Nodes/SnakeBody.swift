//
//  SnakeBody.swift
//  Snake
//
//  Created by 1 on 01.06.2022.
//

import SpriteKit

enum BodyType: UInt32 {
    case snakeHead = 2
    case target = 4
    case barrier = 8
    case border = 16
}

class SnakeBody: SKSpriteNode {
    
    func configureSnakeHead() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        self.physicsBody?.categoryBitMask = BodyType.snakeHead.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.target.rawValue
        self.physicsBody?.collisionBitMask = BodyType.border.rawValue
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
    }
    
    func breakSnakeHead() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
