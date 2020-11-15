//
//  LetterView.swift
//  Word Flakes
//
//  Created by Tatyana kudryavtseva on 23/07/16.
//  Copyright © 2016 Organized Chaos. All rights reserved.
//

import UIKit

class LetterView: UIButton {
    
    
    // colors
    
    let borderBlueColor = UIColor(red: 26.0/255.0, green: 8.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    let borderYellowColor = UIColor(red: 230.0/255.0, green: 152.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    let borderRedColor = UIColor(red: 171.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    let borderPurpleColor = UIColor(red: 166.0/255.0, green: 4.0/255.0, blue: 181.0/255.0, alpha: 1.0)

    

    //let width  : CGFloat!
    //let height : CGFloat = 20
    var defaultFontColor = UIColor(red: 0, green: 0, blue: 0.453 , alpha: 1.0)
    var multiplier = 1
    var isSpecial = false
    
    
    
    // properties
    

    
    let initialVelocity = 4.0
    
    
    var velocity : (x: Double, y: Double)!
    
    
    var age = 0 as Int
    
    var maximumAge : Int!
    
    //var xVelocity = 1.0
    //var yVelocity = 0.5
    
    var rotationAngle :Double!
    var angularVelocity : Double!
    

    //var tileButton : UIButton!
    var letter : String!
    var letterValue : Int!
    

    init(boardFrame : CGRect) {
    
        
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        
        self.userInteractionEnabled = true
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center

        self.backgroundColor = UIColor.whiteColor()
        
        
        //let image = UIImage(named: "white-marble-2048") as UIImage?
        //self.setBackgroundImage(image, forState: .Normal)
        
        
        self.layer.cornerRadius = 0.2 * self.frame.width
        self.clipsToBounds = true
        
        
        self.layer.borderWidth = 2
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.layer.shadowRadius = 15.0
       
        self.layer.masksToBounds = false
        
        let path = UIBezierPath(rect: self.bounds)
        self.layer.shadowPath = path.CGPath
        
        
        setRandom(boardFrame)
        
        letterValue = getCharValue(letter)
        
        setPhysics(boardFrame)
        
        if !isSpecial{
        
        decorate(letter, multiplier: multiplier, value: letterValue)
            
        }
        
        else{
            decorateSpecial(letter)
            
        }
        
        
        
        
        // how many times it bumps against the wall
        maximumAge = 1 + Int(arc4random_uniform(3))
        
       
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setChar(char: String){
        
        
    }
    
    func rotate(angle : Double){
        
     self.transform = CGAffineTransformMakeRotation(CGFloat(angle * M_PI_2/90.0))
        //pointDisplay.transform = CGAffineTransformMakeRotation(CGFloat(degree * M_PI_2/90.0))

    }
    
    func scale(dx: Double, dy: Double){
        self.transform = CGAffineTransformMakeScale(CGFloat(dx), CGFloat(dy))
    }
    
    func getCharValue(char : String) -> Int{
        
        switch char {
        case char where "EAIONRTLS".containsString(char):
            return 1
        case char where "DU".containsString(char):
            return 2
        case char where "BCMPG".containsString(char):
            return 3
        case char where "FHWY".containsString(char):
            return 4
        case char where "V".containsString(char):
            return 5
        case char where "K".containsString(char):
            return 7
        case char where "JX".containsString(char):
            return 10
        case char where "Z".containsString(char):
            return 15
        case char where "Q".containsString(char):
            return 15
        case char where char == "QU":
            return 7
        case char where char == "ING":
            return 0
        case char where char == "ED":
            return 3
        case char where char == "ER":
            return 2
            
        default:
            return 0
        }
        
        
    }
    
    func getChars() -> String {
        return letter;
    }
    
    
    //To tell the stack view how to lay out your button, you also need to provide an intrinsic content size for it. To do this, override the intrinsicContentSize method to match the size you specified in Interface Builder like this:

    
   // override func intrinsicContentSize() -> CGSize {
   //     return CGSize(width: 240, height: 44)
   // }
    
    
    func applyCurvedShadow(view: UIView) {
        let size = view.bounds.size
        let width = size.width
        let height = size.height
        let depth = CGFloat(11.0)
        let lessDepth = 0.8 * depth
        let curvyness = CGFloat(5)
        let radius = CGFloat(1)
        
        let path = UIBezierPath()
        
        // top left
        path.moveToPoint(CGPoint(x: radius, y: height))
        
        // top right
        path.addLineToPoint(CGPoint(x: width - 2*radius, y: height))
        
        // bottom right + a little extra
        path.addLineToPoint(CGPoint(x: width - 2*radius, y: height + depth))
        
        // path to bottom left via curve
        path.addCurveToPoint(CGPoint(x: radius, y: height + depth),
                             controlPoint1: CGPoint(x: width - curvyness, y: height + lessDepth - curvyness),
                             controlPoint2: CGPoint(x: curvyness, y: height + lessDepth - curvyness))
        
        let layer = view.layer
        layer.shadowPath = path.CGPath
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: 0, height: -3)
    }

    func applyPlainShadow(view: UIView) {
        let layer = view.layer
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
    }
    
    //func getVelocity() -> (Double, Double) {
    //    return (xVelocity, yVelocity)
    //
    //}
    
    //func setVelocity(xv : Double, yv : Double){
    //    xVelocity = xv
    //    yVelocity = yv
    //}
    
    //func getAngularVelocity() -> Double {
    //    return angularVelocity
    //}
    
    //func setRotationAngle(angle : Double){
    //    rotationAngle = angle
    //}
    
    
    func setRandom(boardFrame : CGRect){
        
        // randomize seed - REMOVE IF WANT REPEATABLE random values
        
        srand(UInt32(time(nil))) //EDIT ME: YOU prob only need do this once in begining
    
        // select random letter
    
        var letterFrequency = [18, 4, 4, 8, 24, 4, 4, 4, 18, 2, 2, 8, 4, 12, 16, 4, 1, 12, 10, 12, 8, 4, 4, 2, 4, 2, 1, 2, 1, 1, 2, 80, 0]
        var allLetters = Array(65...90).map {String(UnicodeScalar($0))}
        
        
        allLetters += ["QU", "ED", "ING", "?", "ER", "*", "BOOM"]
        
        
        
        
        
        for j in (0..<(letterFrequency.count-1)){
            letterFrequency[j+1] += letterFrequency[j]
        }
        
        let r = Int( arc4random_uniform(UInt32(letterFrequency[letterFrequency.count-1] + 1)))

        
        var i = 0
        while (letterFrequency[i] < r){
            i += 1
        }
        

        letter = allLetters[i]
        
        if (letter == "*") || (letter == "BOOM"){
            self.isSpecial = true
            return
        }
        
        setWordMult()
        
    
    }
    
    func setPhysics(boardFrame : CGRect){
        
        // set random velocity
        
        
        // set random velocity angle and velocity component
        
        let initialVelocityAngle = drand48() * 360
        
        velocity = (initialVelocity * cos(initialVelocityAngle), initialVelocity * sin (initialVelocityAngle))
        
        // set initial rotation angle
        
        rotationAngle = drand48() * 360
        
        // set angular velocity
        
        angularVelocity = (drand48() > 0.5) ? 1 : -1
        
        // set position
        
        var x, y : CGFloat!
        
        if (arc4random_uniform(2) == 1){
            // veritical
            x = CGFloat(drand48()) * boardFrame.width + boardFrame.minX
            y = (velocity.y > 0) ? boardFrame.minY : boardFrame.maxY
        }
        else{
            y = CGFloat(drand48()) * boardFrame.height + boardFrame.minY
            x = (velocity.x > 0) ? boardFrame.minX : boardFrame.maxX
        }
        
        
        
        self.frame = CGRectMake(x, y, 40, 40)
        
        
    }
    
    //Function for decorating normal letter Tiles
    func decorate(letter: String!, multiplier: Int, value: Int ){
        
        let fontCol = [defaultFontColor,
                       UIColor(red: 1.0, green: 0.2745, blue: 0, alpha: 1.0),
                       UIColor.whiteColor(),
                       UIColor.clearColor(),
                       UIColor.whiteColor()]
        
        let col = [UIColor.whiteColor(), UIColor(red: 0.953, green: 0.953, blue: 0.647, alpha: 1.0), UIColor(red: 0.992, green: 0.329, blue: 0.243, alpha: 1.0) , UIColor(red: 0.7686, green: 0.540, blue: 0.8117, alpha: 1.0),  UIColor(red: 0.7686, green: 0.540, blue: 0.8117, alpha: 1.0)]
        
        let borderCol = [UIColor(red: 0.01, green: 0.02, blue: 0.627, alpha: 1.0),
                         UIColor(red: 0.902, green: 152.0/255.0, blue: 0.2157, alpha: 1.0),
                         UIColor(red: 150.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0),
                         UIColor.clearColor(),
                         UIColor(red: 110/255.0, green: 0.02, blue: 170/255.0, alpha: 1.0)]
        
        let shadowCol = [UIColor.whiteColor(),
                         UIColor(red: 0.98, green: 1, blue: 0.6666, alpha: 1.0),
                         UIColor(red: 1, green: 0.333, blue: 0.333, alpha: 1.0),
                         UIColor.clearColor(),
                         UIColor(red: 0.7686, green: 0.540, blue: 0.8117, alpha: 1.0)]
        
        let fontSize = [CGFloat(23), CGFloat(23),CGFloat(17), CGFloat(15)] //Font size depends on how many characters the tile has (Usually 1)
        
        
        let attrs1 : [String: AnyObject] = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: fontSize[letter.characters.count])!, NSForegroundColorAttributeName: fontCol[multiplier-1]]
        
        let attributedText = NSMutableAttributedString(string:letter, attributes: attrs1)
        
        let valueString = "\(value)"
        
        
        let attrs2 : [String: AnyObject] = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 10)!, NSBaselineOffsetAttributeName: -5, NSForegroundColorAttributeName: fontCol[multiplier-1]]
        
        
        attributedText.appendAttributedString(NSAttributedString(string: valueString, attributes: attrs2))
        
        

        self.backgroundColor = col[multiplier-1]
        self.layer.borderColor = borderCol[multiplier - 1].CGColor
        self.layer.shadowColor = shadowCol[multiplier-1].CGColor
        self.setAttributedTitle(attributedText, forState: UIControlState.Normal)
        

    }
    
    func incrementAge() -> Bool{
        
        
        age += 1
        return true
    }
    
    func isAged() -> Bool{
        return age >= maximumAge
    }

    
    func setWordMult(){
        // word multiplier
        let r = Int( arc4random_uniform(300))
        
        if (r % 10 == 0){
            multiplier = 2
        }
        else if (r % 21 == 0){
            multiplier = 3
        }
        else if(r == 2){
            multiplier = 5
        }
        
    }
    
    
    
    func addEmitter(){
        
         
         let emitter = CAEmitterLayer()
         emitter.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
         emitter.emitterSize = self.bounds.size
         emitter.emitterMode = kCAEmitterLayerAdditive
        
        
         emitter.emitterShape = kCAEmitterLayerRectangle
        
        
         self.layer.addSublayer(emitter)
        
        
        
         let texture:UIImage? = UIImage(named:"Spark")
         //assert(texture != nil, "particle image not found")
         
         //3
         let emitterCell = CAEmitterCell()
         
         //4
         emitterCell.contents = texture!.CGImage
         
         //5
         emitterCell.name = "cell"
         
         //6
         emitterCell.birthRate = 100
         emitterCell.lifetime = 0.5
         
         //7
         emitterCell.blueRange = 0.33
         //emitterCell.greenRange = 0.33
         // emitterCell.redRange = 0.33
        
          //emitterCell.blueSpeed = -0.33
         emitterCell.greenSpeed = -0.33
         //emitterCell.redSpeed = -0.33
         
         //8
         emitterCell.velocity = 100
         emitterCell.velocityRange = 10
        
        //emitterCell.speed = 200
        
         
         //9
         emitterCell.scaleRange = 0.2
         emitterCell.scaleSpeed = -0.1
         emitterCell.scale = 0.1
         emitterCell.yAcceleration = 100 //* (-CGFloat(velocity.y))
         emitterCell.xAcceleration = 0 //100 *  (-CGFloat(velocity.x))
        
         emitterCell.spin = CGFloat(angularVelocity)
        
        
        
        emitterCell.emissionLatitude = -CGFloat(velocity.x)
        emitterCell.emissionLongitude = -CGFloat(velocity.y)
        
         //10
        
        
        emitterCell.emissionRange = CGFloat(2*M_PI)
         
         //11
         emitter.emitterCells = [emitterCell]
         
         
    }
    
    
    func updateCoordinates(x : CGFloat, y : CGFloat, speed : Double){
        
        self.frame = CGRectMake(x, y, 40, 40)
        
        velocity.x *= speed
        velocity.y *= speed
    }
    
    
    func decorateSpecial(identifier: String! ){
        if identifier == "*"{
            self.backgroundColor = UIColor.clearColor()
            
            //self.layer.borderColor = UIColor.cyanColor().CGColor
           // self.layer.shadowColor = UIColor.blueColor().CGColor
            self.layer.borderWidth = 0
            let image = UIImage(named: "BriefCase") as UIImage?
            
            self.setImage(image, forState: .Normal)

            self.transform = CGAffineTransformMakeScale(0.67, 0.82)
            
            
            
        
        }
        
        if identifier == "BOOM"{
            self.backgroundColor = UIColor.clearColor()
            self.layer.borderWidth = 0
            let image = UIImage(named: "bomb") as UIImage?
            
            self.setImage(image, forState: .Normal)
            
            self.transform = CGAffineTransformMakeScale(0.67, 0.82)
            
            self.addFireEmitter()

        
        }
        
        
        
    }
    
    
    
    func addFireEmitter(){
        
  
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        emitter.emitterSize = CGSize(width: 1.0, height: 1.0)
        emitter.emitterMode = kCAEmitterLayerAdditive
        
        
        emitter.emitterShape = kCAEmitterLayerRectangle
        
        
        
        self.layer.addSublayer(emitter)
        
        
        
        let texture:UIImage? = UIImage(named:"Spark")
        //assert(texture != nil, "particle image not found")
        
        //3
        let emitterCell = CAEmitterCell()
        
    
        
        //4
        emitterCell.contents = texture!.CGImage
        
        //5
        emitterCell.name = "cell"
        
        //6
        emitterCell.birthRate = 2000
        emitterCell.lifetime = 1
        
        emitterCell.color = UIColor.redColor().CGColor
        
        //7
        //emitterCell.blueRange = 0.33
        //emitterCell.greenRange = 0.33
         emitterCell.redRange = 0.33
        
        //emitterCell.blueSpeed = -0.33
        emitterCell.greenSpeed = -0.33
        //emitterCell.redSpeed = -0.33
        
        //8
        emitterCell.velocity = 100
        emitterCell.velocityRange = 10
        
        //emitterCell.speed = 500
        
        
        //9
        emitterCell.scaleRange = 0.2
        emitterCell.scaleSpeed = -0.1
        emitterCell.scale = 0.1
        emitterCell.yAcceleration = 100 //* (-CGFloat(velocity.y))
        emitterCell.xAcceleration = 0 //100 *  (-CGFloat(velocity.x))
        
        emitterCell.spin = CGFloat(angularVelocity)
        
        
        
        emitterCell.emissionLatitude = -CGFloat(velocity.x)
        emitterCell.emissionLongitude = -CGFloat(velocity.y)
        
        //10
        
        
        emitterCell.emissionRange = CGFloat(2*M_PI)
        
        //11
        emitter.emitterCells = [emitterCell]
        
        
    }

}




// setChar happens here

/*
 
 let emitter = CAEmitterLayer()
 emitter.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
 emitter.emitterSize = self.bounds.size
 emitter.emitterMode = kCAEmitterLayerAdditive
 emitter.emitterShape = kCAEmitterLayerRectangle
 
 self.layer.addSublayer(emitter)
 
 let texture:UIImage? = UIImage(named:"Particle")
 assert(texture != nil, "particle image not found")
 
 //3
 let emitterCell = CAEmitterCell()
 
 //4
 emitterCell.contents = texture!.CGImage
 
 //5
 emitterCell.name = "cell"
 
 //6
 emitterCell.birthRate = 100
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
 
 */
