import UIKit

class StardustView:UIView {
    private var emitter:CAEmitterLayer!
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        
        //initialize the emitter
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x:self.bounds.size.width/2, y:self.bounds.size.height/2)
        emitter.emitterSize = self.bounds.size
        emitter.emitterMode = CAEmitterLayerEmitterMode.outline
        emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        //initialize the emitter
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x:self.bounds.size.width/2, y:self.bounds.size.height/2)
        emitter.emitterSize = self.bounds.size
        emitter.emitterMode = CAEmitterLayerEmitterMode.outline
        emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
    }
    
    /*override*/ class func layerClass() -> AnyClass {
        //configure the UIView to have emitter layer
        return CAEmitterLayer.self
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview == nil {
            return
        }
        
        //load the texture image
        let texture:UIImage? = UIImage(named:"Particle")
        assert(texture != nil, "particle image not found")
        
        //create new emitter cell
        let emitterCell = CAEmitterCell()
        emitterCell.contents = texture!.cgImage
        emitterCell.name = "cell"
        emitterCell.birthRate = 200
        emitterCell.lifetime = 1.5
        emitterCell.blueRange = 0.33
        emitterCell.blueSpeed = -0.33
        emitterCell.yAcceleration = 100
        emitterCell.xAcceleration = -200
        emitterCell.velocity = 100
        emitterCell.velocityRange = 40
        emitterCell.scaleRange = 0.5
        emitterCell.scaleSpeed = -0.2
        emitterCell.emissionRange = CGFloat(Double.pi * 2)
        
        let emitter = self.layer as! CAEmitterLayer
        emitter.emitterCells = [emitterCell]
    }
    
    func disableEmitterCell() {
        emitter.setValue(0, forKeyPath: "emitterCells.cell.birthRate")
    }
}
