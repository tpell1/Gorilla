//
//  TurtleSprite.swift
//  Gorilla
//
//  Created by Travis Pell on 24/03/2020.
//  Copyright © 2020 Travis Pell. All rights reserved.
//

import Foundation
import SpriteKit
import Physics

class TurtleSprite: SKSpriteNode {
    private var height = 60
    private var width = 50
    private var sizeOfPlatform: CGFloat = 3
    private var timer: Timer?
    private var timerBool = false
    private var shellArray: [ShellItem] = []
    private var iteration = 0
    
    // Default constructor, creates a turtle character with one life
    init(x: CGFloat, y: CGFloat) {
        let texture = SKTexture(imageNamed: "turtle.png") // Use the turtle texture
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: width, height: height))
        self.position = CGPoint(x: x, y: y)
        
        ////////////// My Physics ////////
        physicsObj = PhysicsObject(withNode: self)
        
        self.timer = Timer(timeInterval: TimeInterval(sizeOfPlatform*0.5), repeats: true, block: timerWalk)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    convenience init(x: CGFloat, y: CGFloat, sizeOfPlatform: Int) {
        self.init(x: x, y: y)
        self.sizeOfPlatform = CGFloat(sizeOfPlatform)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walk() {
        let move = SKAction.move(to: CGPoint(x: self.position.x + sizeOfPlatform*BlockSprite.BLOCK_SIZE, y: self.position.y), duration: TimeInterval(0.5*sizeOfPlatform))
        self.run(move)
    }
    
    func walkBack() {
        let move = SKAction.move(to: CGPoint(x: self.position.x - sizeOfPlatform*BlockSprite.BLOCK_SIZE, y: self.position.y), duration: TimeInterval(0.5*sizeOfPlatform))
        self.run(move)
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        physicsObj?.index = -1
    }
    
    @objc func timerWalk(timer: Timer) {
        if(timerBool) {
            walkBack()
        } else {
            walk()
        }
        if (canSeeMartinio() && iteration%1==0) {
            throwShell()
            
        }
        timerBool = !timerBool
        iteration = iteration + 1
    }
    
    func collision(contact: PhysicsCollision) {
        let node = contact.a.node
        if (node is MartinioSprite) {
            let martinio = contact.a.node as! MartinioSprite
            if ((martinio.physicsObj?.velocity.dy)!) < CGFloat(-30) {
                die()
            } else {
                martinio.shrink()
            }
        }
    }
    
    func canSeeMartinio() -> Bool {
        if let martinio = self.parent?.childNode(withName: "Martinio") {
            let martinioX = martinio.position.x
            if (timerBool) {
                return martinioX < self.position.x
            } else {
                return martinioX > self.position.x
            }
        }
        return false
    }
    
    func die() {
        removeFromParent()
    }
    
    // Basic throw shell in a direction
    func throwShell() {
        let shell = ShellItem(x: CGFloat(self.position.x), y: 60)
        if (!timerBool) {
            shell.physicsObj?.velocity = CGVector(dx: 0, dy: 0)
            shell.position.x += 5
            shell.position.y += 100
            self.parent?.addChild(shell)
            shell.move(toParent: self.parent!)
            shell.startMove(direction: 1)
        } else {
            shell.physicsObj?.velocity = CGVector(dx: 0, dy: 0)
            shell.position.x -= 5
            shell.position.y = self.position.y + 30
            self.parent?.addChild(shell)
            shell.move(toParent: self.parent!)
            shell.startMove(direction: -1)
        }
        
        // Only allow three shells to exist at one point
        if (shellArray.count > 3) {
            shellArray[0].removeFromParent()
            shellArray.remove(at: 0)
        }
        shellArray.append(shell)
    }
}
