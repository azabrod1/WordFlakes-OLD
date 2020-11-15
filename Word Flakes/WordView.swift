//
//  WordView.swift
//  Word Flakes
//
//  Created by Tatyana kudryavtseva on 23/07/16.
//  Copyright © 2016 Organized Chaos. All rights reserved.
//

import UIKit

class WordView: UIView {

    
    //var playButton : UIButton?
    
    
    //var label = UILabel()
    
    let lengthBonus = [0, 0, 0, 0, 0, 5, 30, 60, 120, 200, 350, 500, 750, 1500, 2000, 5000, 7500]
    
    //                [0, 1, 2, 3, 4, 5, 6 , 7,  8,   9,    10   11  12   13   14    15   16  17]
    
    var tileRack = [LetterView]()
    private var strWord = ""
    var dictionary = Set<String>()
    
    
    
    required init? (coder aDecoder :NSCoder){
        super.init(coder: aDecoder)
        loadDictionary()
        
    }
    
    
    func submitWord() -> Int{
        
        var rackScore  = 0
        var multiplier = 1
        var temp : [LetterView] = []
        
        
        print("Number of letters: \(temp.count)")
        
        if dictionary.contains(strWord) && strWord.characters.count > 3 {
            
            for letter in self.tileRack{
                rackScore += letter.letterValue
                multiplier *= letter.multiplier
                temp += [letter]
                
            }
            rackScore *= multiplier
            rackScore += lengthBonus[strWord.characters.count]
            self.tileRack.removeAll() // destroy it before the animation, so can add letters while anim runs
            self.strWord = ""
            
            UIView.animateWithDuration(3, animations: {
                // animation starts
                for letter in temp {
                    
                    letter.addEmitter()
                    letter.frame.offsetInPlace(dx: (self.superview?.frame.width)!/2,
                        dy: (-(self.superview?.frame.height)!-2*letter.frame.height))
                    letter.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    letter.setTitle("", forState: UIControlState.Normal)
                }
                
                // animation ends
                
               }, completion: {(i : Bool) in
                    
                    // completion block
                    for letter in temp{
                        letter.removeFromSuperview()
                    }
                
            }) // end of completion block
        }
            
            
        else{
            //Invalid Word
            
            for l in self.tileRack{
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                
                animation.fromValue = NSValue(CGPoint: CGPointMake(l.center.x, l.center.y - 5))
                animation.toValue = NSValue(CGPoint: CGPointMake(l.center.x, l.center.y + 5))
                l.layer.addAnimation(animation, forKey: "position")
            }
        }
        
        return rackScore
    }
    
    
    func linesFromResource(fileName: String) throws -> [String] {
        
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: nil) else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError, userInfo: [ NSFilePathErrorKey : fileName ])
        }
        let content = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        return content.componentsSeparatedByString("\n")
    }
    
    
    func loadDictionary() -> Bool{
        
        let fileLocation  = NSBundle.mainBundle().pathForResource("wordList", ofType: "txt")!
        
        
        let text : String
        
        
        do{
            text = try String(contentsOfFile: fileLocation)
        }
        catch{
            text = ""
            return false
        }
        
        dictionary = Set(text.componentsSeparatedByString("\n"))
        
        
        return true
        
    }
    
    func addLetter(button : LetterView){
        
        var x : CGFloat!
        let count = self.tileRack.count
        let w : CGFloat!
        
        // width of a letter tile in the word (if count == 0, does not matter)
        if count > 0 {
            w = tileRack.last!.frame.width
        } else {
            w = 0
        }
        
        // position of the letter (will be adjusted for a potential race condition later)
        x = 15 + (w + 3) * min(7, CGFloat(count))
        
        
        UIView.animateWithDuration(1, animations: {
            
            
            if (count >= 8){
                
                for l in self.tileRack {
                    l.frame.offsetInPlace(dx: -(l.frame.width  + 3.0), dy: 0)
                }
            }
            self.tileRack.append(button)
            
            button.transform = CGAffineTransformMakeScale(0.8, 0.8)
            
            button.frame = CGRect(x: x, y: (button.superview?.frame.maxY)! - 40 , width: button.frame.width , height: button.frame.height )
            button.layer.shadowOpacity = 0.3
            self.strWord += button.getChars()
            
            // end of animation
            
            } , completion: {(i : Bool) in
                
                
                if (count >= 7 && count < self.tileRack.count - 1){
                    
                    // by the time this letter lands, another one is selected, so the original letter
                    // needs to be shifted
                    
                    let adj = (button.frame.width  + 3.0) * CGFloat(self.tileRack.count - count - 1)
                    
                    x = x - adj
                    
                }
                
                
                button.removeFromSuperview()
                button.frame = CGRect(x: x, y: 0, width: button.frame.width , height: button.frame.height )
                
                self.addSubview(button)
                
                self.bringSubviewToFront(button)
                
                
        }) // end of completion
    
    }
    
    func removeLastLetter() -> Int{
        
        
        if (tileRack.count == 0){return 0}
        
        
        let letter = tileRack.removeLast() as LetterView
        
        
        UIView.animateWithDuration(1, animations: {
            
            // animation starts
            letter.frame.offsetInPlace(dx: 0, dy: 50)
            
            letter.backgroundColor = UIColor.clearColor()
            
            //animation ends
            }, completion: {(i : Bool) in
                // after animation
                
                letter.removeFromSuperview()
                
                letter.hidden = true
                
                self.strWord = ""
                
                for letter in self.tileRack{
                    self.strWord += letter.getChars()
                    
                }
                
                if (self.tileRack.count >= 8){
                    for l in self.tileRack {
                        l.frame.offsetInPlace(dx: +(l.frame.width  + 3.0), dy: 0)
                    }
                }
                
                
                
        }) // end of completion
        
        return 1
        
    }
    
    func removeAll() -> Int{
        
        if (tileRack.count == 0){
            return 0
        }
        
        let score = tileRack.count
        
        UIView.animateWithDuration(1, animations: {
            
            for letter in self.tileRack{
               
            // animation starts
                letter.frame.offsetInPlace(dx: 0, dy: 50)
            
                letter.backgroundColor = UIColor.clearColor()
            }
            
            //animation ends
            }, completion: {(i : Bool) in
                // after animation
                for letter in self.tileRack{
                    letter.removeFromSuperview()
                    letter.hidden = true
                }
                
                self.strWord = ""
                
                
        }) // end of completion
        
        
        self.tileRack.removeAll()
        self.strWord = ""
    
        return score
    }
    
    
    func isWord() -> Bool{
        
        if(dictionary.contains(strWord) && strWord.characters.count > 2){
            
            return true
        }
        
        return false
        
    }
    
        
    }

    

