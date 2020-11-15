//
//  HighScoreController.swift
//  Word Flakes
//
//  Created by Tatyana kudryavtseva on 31/07/16.
//  Copyright © 2016 Organized Chaos. All rights reserved.
//

import UIKit

class HighScoreController: UIViewController {
    
    var menuController : MenuController!
    
    var highScores: [Int]!

    @IBOutlet weak var menuReturn: UIButton!
    @IBOutlet weak var scoresText: UITextView!

    @IBOutlet weak var highScoreView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        highScores = menuController.mainController.getHighScores()
        
        
        
        var toDisplay : String = ""
        
        
        if highScores.isEmpty{
            toDisplay = "You have no High Scores! That means you are either really bad...or should play more!"
        }
        else{
                toDisplay += "  \(1) .     \(highScores[0])\n" //For better alignment
            for i in 1..<highScores.count{
                toDisplay += "  \(i+1) .    \(highScores[i])\n"

            }
            scoresText.text = toDisplay
            scoresText.isEditable = false
            scoresText.allowsEditingTextAttributes = false
            
            scoresText.font = UIFont(name: "Noteworthy-Bold" , size: 19)
            formatButton(b:menuReturn)
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    /*override*/ func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    @IBAction func menuReturnPressed(sender: UIButton) {
        self.dismiss(animated:true, completion: {})
    }

    
    func formatButton(b : UIButton){
        
        //b.setTitleColor(UIColor(red: 175/255.0, green:175/255.0, blue: 237/255.0, alpha: 1.0), forState: UIControlState.Normal)
        
        b.setTitleColor(UIColor.orange, for: UIControl.State.normal)
        b.setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        b.layer.borderWidth = 2
        b.layer.borderColor = (UIColor.orange).cgColor
        
        
        b.layer.cornerRadius = 10
        b.layer.shadowOffset = CGSize(width: 2, height: 2)
        b.layer.shadowOpacity = 1.0
        b.layer.shadowColor = UIColor.white.cgColor
        
        b.layer.masksToBounds = true
        
        
        
        //gradient color
        let btnGradient = CAGradientLayer()
        btnGradient.frame = b.bounds
        btnGradient.colors =
            [UIColor(red: 102.0/255.0, green:102.0/255.0, blue: 102.0/255.0, alpha: 1.0).cgColor,
             UIColor(red: 51/255, green:51/255, blue: 51/255, alpha: 1).cgColor]
        
        btnGradient.masksToBounds = true
        
        
        b.layer.insertSublayer(btnGradient, at: 0)
        
        
    }
    
    
    
    
    
    
    

}
