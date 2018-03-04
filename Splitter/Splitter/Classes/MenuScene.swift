//
//  GameScene.swift
//  Splitter
//
//  Created by Hieu Nguyen on 12/15/17.
//  Copyright © 2017 HM Dev. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class MainMenu: SKScene{
    
    //Variable Declarations
    let x_Origin = 0
    let y_Origin = 0
    let y_btnPos = 160
    
    //Buttons
    let Level_1:SKSpriteNode = SKSpriteNode(imageNamed: "Level_1_btn")
    let Level_2:SKSpriteNode = SKSpriteNode(imageNamed: "Level_2_btn")
    let Level_3:SKSpriteNode = SKSpriteNode(imageNamed: "Level_3_btn")

    
    //------------------------------------------------------------------------------------------------------
    override func didMove(to view: SKView) {
        InitGame()
        print("Hello")
        
        
    }
    
    //------------------------------------------------------------------------------------------------------
    //Functions
    func InitObjects(){
        //Programmatically add buttons
        Level_1.position = CGPoint(x: x_Origin, y: y_btnPos)
        Level_1.name = "level1"
        Level_1.isUserInteractionEnabled = false
        self.addChild(Level_1)
        Level_2.position = CGPoint(x: x_Origin, y: (y_btnPos + (y_btnPos * -1)))
        Level_2.name = "level2"
        Level_2.isUserInteractionEnabled = false
        self.addChild(Level_2)
        Level_3.position = CGPoint(x: x_Origin, y: (y_btnPos + (y_btnPos * -2)))
        Level_3.name = "level3"
        Level_3.isUserInteractionEnabled = false
        self.addChild(Level_3)
    }
    
    func sceneTransition(scene_name: String){
        print(scene_name)
        if let view = self.view {
            // Load the SKScene from 'Level_1.sks'
            if let scene = SKScene(fileNamed: scene_name) {
                scene.scaleMode = .aspectFill
                view.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1.0))
            }
            view.showsFPS = true
            view.showsNodeCount = true
            view.ignoresSiblingOrder = true
        }
    }
    
    //Create all our stuff
    func InitGame(){
        InitObjects()
        
        //Background music
        let bg:SKAudioNode = SKAudioNode(fileNamed: "tropics.mp3")
        bg.autoplayLooped = true
        self.addChild(bg)
    }
    //------------------------------------------------------------------------------------------------------
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            let whatnode = touchedNode.name!
            
            //Logic for what level
            switch whatnode{
            case "level1":
                sceneTransition(scene_name: "Level_1")
            case "level2":
                sceneTransition(scene_name: "Level_2")
            case "level3":
                sceneTransition(scene_name: "Level_3")
            default:
                print("")
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


