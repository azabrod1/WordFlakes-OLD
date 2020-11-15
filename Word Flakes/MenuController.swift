//
//  MenuController.swift
//  Word Flakes
//
//  Created by Tatyana kudryavtseva on 28/07/16.
//  Copyright © 2016 Organized Chaos. All rights reserved.
//

import UIKit

class MenuController: UIViewController {

    // MARK: controls
    
    
    @IBOutlet weak var resumeButton: UIButton!
    
    @IBOutlet weak var restartButton: UIButton!
    
    @IBOutlet weak var InstructionsButton: UIButton!
    
    @IBOutlet weak var highScoreButton: UIButton!
    
    
    // MARK: properties
    
    var mainController : MainController!
    
    
    // MARK: control actions
    
 
    @IBAction func resumeTouchedDown(sender: UIButton) {
        animateButtonPress(sender)
    }
    
    @IBAction func restartTouchedDown(sender: UIButton) {
        animateButtonPress(sender)
    }
    
    @IBAction func instructionsTouchedDown(sender: UIButton) {
        animateButtonPress(sender)
    }
 

    
    @IBAction func HighScoreButtonPressed(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("High Score Controller") as! HighScoreController
        
        vc.menuController = self
        
        vc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func restartPressed(sender: UIButton) {
        
  
            self.dismissViewControllerAnimated(true, completion: {});
            
            mainController.run()
    
    
    }
    
    @IBAction func resumePressed(sender: UIButton){
        
        self.dismissViewControllerAnimated(true, completion: {});
        mainController.gameState = mainController.gameStateBeforePause
        
    }
    
    
    @IBAction func instructionsPressed(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatButton(resumeButton)
        formatButton(restartButton)
        formatButton(InstructionsButton)
        formatButton(highScoreButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: formatting
    
    func formatButton(b : UIButton){
        
        //b.backgroundColor = UIColor.whiteColor()
        b.setTitleColor(UIColor(red: 175/255.0, green:175/255.0, blue: 237/255.0, alpha: 1.0), forState: UIControlState.Normal)
        b.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        b.layer.borderWidth = 2
        b.layer.borderColor = UIColor(red: 40/255.0, green:40/255.0, blue: 255/255.0, alpha: 1.0).CGColor
        
        
        b.layer.cornerRadius = 10
        b.layer.shadowOffset = CGSize(width: 2, height: 2)
        b.layer.shadowOpacity = 1.0
        b.layer.shadowColor = UIColor.whiteColor().CGColor
        
        b.layer.masksToBounds = true
        
        
        //gradient color
        let btnGradient = CAGradientLayer()
        btnGradient.frame = b.bounds
        btnGradient.colors =
            [UIColor(red: 102.0/255.0, green:102.0/255.0, blue: 102.0/255.0, alpha: 1.0).CGColor,
             UIColor(red: 51/255, green:51/255, blue: 51/255, alpha: 1).CGColor]
        
        btnGradient.masksToBounds = true
        
        b.layer.insertSublayer(btnGradient, atIndex: 0)
    
        
    }
    
    func animateButtonPress(b : UIButton){
        

        UIView.animateWithDuration(0.1, animations: {
            b.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }, completion: {(i : Bool) in
            b.transform = CGAffineTransformIdentity})
        
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
}
