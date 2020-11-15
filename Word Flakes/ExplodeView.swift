//
//  ExplodeView.swift
//  Word Flakes
//
//  Created by Tatyana kudryavtseva on 25/07/16.
//  Copyright © 2016 Organized Chaos. All rights reserved.
//

import UIKit

class ExplodeView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
    private var emitter:CAEmitterLayer!
    
    //2 configure the UIView to have an emitter layer
    override class func layerClass() -> AnyClass {
        print("In emitter class")
        
        return CAEmitterLayer.self
    }
    
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)!
        
        
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        emitter.emitterSize = self.bounds.size
        emitter.emitterMode = kCAEmitterLayerAdditive
        emitter.emitterShape = kCAEmitterLayerRectangle
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        //initialize the emitter
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        emitter.emitterSize = self.bounds.size
        emitter.emitterMode = kCAEmitterLayerAdditive
        emitter.emitterShape = kCAEmitterLayerRectangle
        
        
        emitter.hidden = false
       
        
    }
    
    override func didMoveToSuperview() {
        //1
        
        print("in didMoveToSuperview")
        
        super.didMoveToSuperview()
        if self.superview == nil {
            return
        }
        
        //2
        let texture:UIImage? = UIImage(named:"Particle")
        assert(texture != nil, "particle image not found")
        
        //3
        let emitterCell = CAEmitterCell()
        
        //4
        emitterCell.contents = texture!.CGImage
        
        //5
        emitterCell.name = "cell"
        
        //6
        emitterCell.birthRate = 1000
        emitterCell.lifetime = 0.75
        
        //7
        emitterCell.blueRange = 0.33
        emitterCell.blueSpeed = -0.33
        
        //8
        emitterCell.velocity = 160
        emitterCell.velocityRange = 40
        
        //9
        emitterCell.scaleRange = 0.5
        emitterCell.scaleSpeed = -0.2
        
        //10
        emitterCell.emissionRange = CGFloat(M_PI*2)
        
        //11
        emitter.emitterCells = [emitterCell]
    }
}
