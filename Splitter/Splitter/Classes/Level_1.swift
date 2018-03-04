//
//  Level_1.swift
//  Splitter
//
//  Created by Hieu Nguyen on 12/15/17.
//  Copyright © 2017 HM Dev. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class Level_1: SKScene,SKPhysicsContactDelegate {
    //Back Button
    let back_buttonXPos = -260
    let back_ButtonYPos = 592
    let back_button:SKSpriteNode = SKSpriteNode(imageNamed: "Back_logo")
    
    var player1 = SKSpriteNode()
    var left = SKSpriteNode()
    var right = SKSpriteNode()
    var finish = SKSpriteNode()
    
    //Determines left or right
    var isRight : Bool = false
    var isLeft : Bool = false
    var isMoving: Bool = false
    
    //Bitmask Collisions
    let noCategory:UInt32 = 0
    let playerCategory:UInt32 = 0b1             // 1
    let itemCategory:UInt32 = 0b1 << 1          // 2
    
    //------------------------------------------------------------------------------------------------------
    //Functions
    private func initObjects(){
        back_button.position = CGPoint(x: back_buttonXPos, y: back_ButtonYPos)
        back_button.name = "backButton"
        back_button.isUserInteractionEnabled = false
        self.addChild(back_button)
        
        player1 = self.childNode(withName: "Player") as! SKSpriteNode
        player1.physicsBody?.categoryBitMask = playerCategory
        player1.physicsBody?.contactTestBitMask = itemCategory
        player1.position = CGPoint(x: 0, y: -185)
        
        //Last walls, so that we can pin to screen when finish yPos condition is true
        left = self.childNode(withName: "left4") as! SKSpriteNode
        right = self.childNode(withName: "right4") as! SKSpriteNode
        
        //Our finish node
        finish = self.childNode(withName: "FINISH") as! SKSpriteNode
        finish.physicsBody?.categoryBitMask = itemCategory
        finish.physicsBody?.contactTestBitMask = playerCategory
        
    }
    
    func sceneTransition(scene_name: String){
        print(scene_name)
        if let view = self.view {
            if let scene = SKScene(fileNamed: scene_name) {
                scene.scaleMode = .aspectFill
                view.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1.0))
            }
            view.showsFPS = true
            view.showsNodeCount = true
            view.ignoresSiblingOrder = true
        }
    }
    //------------------------------------------------------------------------------------------------------
    
    override func didMove(to view: SKView) {
        //Detect collisions
        self.physicsWorld.contactDelegate = self
        
        initObjects()
        
        //Background music
        let bg:SKAudioNode = SKAudioNode(fileNamed: "tropics.mp3")
        bg.autoplayLooped = true
        self.addChild(bg)
    }
    
    //Handles our Collisions
    func didBegin(_ contact: SKPhysicsContact) {
        //Category bit masks
        let cA:UInt32 = contact.bodyA.categoryBitMask
        let cB:UInt32 = contact.bodyB.categoryBitMask
        
        if cA == playerCategory || cB == playerCategory{
            if contact.bodyB.node != nil{
                
                let otherNode:SKNode = contact.bodyB.node!
                playerDidCollide(with: otherNode)
            }
        }
    }
    
    //Checks if other node is player, ball, or wall
    func playerDidCollide(with other:SKNode){
        _ = other.physicsBody?.categoryBitMask
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            let whatnode = touchedNode.name!
            
            //Logic for what level
            switch whatnode{
            case "backButton":
                sceneTransition(scene_name: "MainMenu")
            default:
                break
            }
        }
        
        //Determines if touch is left or right
        for touch in (touches) {
            let location = touch.location(in: self)
            
            //Determine touch direction
            if(location.x < 0){
                isLeft = true
                isRight = false
                isMoving = true
            }
            
            if(location.x > 0){
                isRight = true
                isLeft = false
                isMoving = true
                
            }
        }
        
        //If left touch then move xPosition by -40
        if(isLeft && isMoving){
            player1.run(SKAction.repeatForever(SKAction.moveBy(x: -40, y: 0, duration: 0.2)))
            
        }
        //If right touch then move xPosition by 40
        if(isRight && isMoving){
            player1.run(SKAction.repeatForever(SKAction.moveBy(x: 40, y: 0, duration: 0.2)))
        }
    }
    
    //Function to move the dog using SKAction to move in increments
    func movePlayer (moveBy: CGFloat, who: SKSpriteNode) {
        let moveAction = SKAction.moveBy(x: moveBy, y: 0, duration: 0.3)  //only change x value, so set y = 0
        let repeatForEver = SKAction.repeatForever(moveAction)      //use SKACTION
        let seq = SKAction.sequence([moveAction, repeatForEver])
        
        //running our action
        who.run(seq)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if (finish.position.y <= 60){
            finish.physicsBody?.pinned = true
            left.physicsBody?.pinned = true
            right.physicsBody?.pinned = true
        }
        if (player1.position.y <= -692){
            sceneTransition(scene_name: "MainMenu")
        }
        
    }
}



