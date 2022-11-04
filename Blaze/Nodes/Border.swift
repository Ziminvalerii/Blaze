//
//  Border.swift
//  Snake
//
//  Created by 1 on 08.06.2022.
//

import SpriteKit

class Border: SKShapeNode {
    
    func configureNode(size: CGSize) {
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = BodyType.border.rawValue
        self.physicsBody?.collisionBitMask = BodyType.snakeHead.rawValue
    }
}
