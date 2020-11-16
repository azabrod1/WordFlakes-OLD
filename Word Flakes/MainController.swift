//
//  ViewController.swift
//  Word Flakes
//
//  Created by Tatyana kudryavtseva on 23/07/16.
//  Copyright © 2016 Organized Chaos. All rights reserved.
//

import UIKit
import Darwin

class MainController: UIViewController {

    
// MARK: controllers
    
    @IBOutlet weak var wordView: WordView!
    @IBOutlet weak var boardView: UIImageView!

    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var backspaceButton: UIButton!
    @IBOutlet weak var lblEnergy: UILabel!
    @IBOutlet weak var lblEnergyAdd: UILabel!
    
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblScoreAdd: UILabel!

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPause: UIButton!
    
// MARK: constants
    
    enum GameState {
        case GameStarted
        case GamePaused
        case GameOver
    }
    
    let COLOR_PLATE = [UIColor( red:  0.564 , green: 0.764, blue:0.9519, alpha: 0.7 ) , UIColor( red:  0.564 , green: 0.88235, blue:0.882, alpha: 0.7 ),  UIColor( red:  0.564 , green: 0.8824, blue:0.7059, alpha: 0.7 ), UIColor( red:  0.564 , green: 0.8824, blue:0.4705, alpha: 0.7 ), UIColor( red:  0.733 , green: 0.8824, blue:0.3529, alpha: 0.7 ) , UIColor( red:  0.8824 , green: 0.8824, blue:0.3829, alpha: 0.7 ),  UIColor( red:  0.9019 , green: 0.8078, blue:0.1960, alpha: 0.85 ),  UIColor( red:  0.9019 , green: 0.63137, blue:0.1960, alpha: 0.85 ) , UIColor( red:  0.9019 , green: 0.39215, blue:0.1960, alpha: 0.85 ), UIColor( red:  0.8019 , green: 0.1960, blue:0.25, alpha: 0.85 ) ]
    
    let defaultTxtColor = UIColor(red: 0.357258, green: 0.740995, blue: 1, alpha: 1)
    
    let INIT_ENERGY: Double = 100
    let EXPONENT   : Double = 0.70
    let TIME_CONST : Double = 0.015
    let TIME_MULT  : Double = 0.00013
    let TIME_INT   : Double = 0.03
    let LOW_ENERGY_MARKER : Double = 75
    let DUR_SPAWNER: Double = 12
    let NUM_CHARS  : Int    = 5
    let SPAWNER_CHARS: Int  = 10
    
    let defaults = UserDefaults.standard
    
 
// MARK: properties
    
    var specialClock = 0.00
    var gameState : GameState!
    var gameStateBeforePause : GameState!
    private var highScores = [Int]()
    private var timer      = Timer()
    
    private var energy      : Double = 0.0
    private var timeElapsed : Double = 0
    private var freeLetters = [LetterView]()
    private var highScore   = 0
    private var score       = 0
    
// MARK: control actions
   
    
    @IBAction func backspaceButtonClicked(_ sender: UIButton) {
    
        if (gameState != GameState.GameStarted){return}
        
        let value = wordView.removeLastLetter()
        
        addScore(scoreAdd:0, energyAdd: -Double(value) , display: true)
        
    }
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
    
        if (gameState == GameState.GameOver){
            // restart the game
            run()
            
        }
        
        let toAdd = wordView.submitWord()
        
        if (toAdd != 0){
            addScore(scoreAdd:toAdd, energyAdd: Double(toAdd ), display: true)
        }
    
    }
    
    
    /*This function identifies the Special Tile and calls approapreite method(s) associated with
   that tile */
    @objc
    func specialActivated(_ tile : LetterView){
        
        if (gameState != GameState.GameStarted) {return}
        
        freeLetters = freeLetters.filter({ $0 != tile })
        
        if tile.letter == "*"{
            activateSpawner(button:tile)
        }
        
        if tile.letter == "BOOM"{
            sonicBoom(button:tile)
        }
    
        
    }
    
    @objc
    func letterClicked(_ button : LetterView){
        
        
        if (gameState != GameState.GameStarted){return}
        
        if (button.superview == wordView){return} // letter is already selected
        
        
        freeLetters = freeLetters.filter({ $0 != button })
        
        
        if (button.letter == "?"){
            button.decorate(letter:"A", multiplier:  button.multiplier, value: button.letterValue)
        }
        
        
        wordView.addLetter(button:button)
        
        
        if (freeLetters.count < NUM_CHARS) || (specialClock > 0){
        
        addFreeLetter()
            
        }
        
    }
    
    
    override func viewDidLoad() {
       
        
        highScores = defaults.object(forKey: "HighScores") as? [Int] ?? [Int]()
        
        if !(highScores.isEmpty){
            highScore = highScores[0]
        }

        
        super.viewDidLoad()
        
        let deleteAll = UILongPressGestureRecognizer(target: self,
                    action: #selector(deleteAll(_:)))
        deleteAll.minimumPressDuration = 0.25
        
        
        self.backspaceButton.addGestureRecognizer(deleteAll)

        //self.setUpLabels()
        
        self.view.sendSubviewToBack(boardView)
        
        /////////// format buttons
        
        formatButtons()

        run()
        
    
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func pausePressed(_ sender: UIButton) {
        
        
        gameStateBeforePause = gameState
        gameState = GameState.GamePaused
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:"MenuController") as! MenuController
        
        vc.mainController = self
        
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        self.present(vc, animated: true, completion: nil)
  
        
    }
    
    // MARK: methods
    @objc
    func deleteAll(_ guesture: UILongPressGestureRecognizer) {
        
        if (gameState != GameState.GameStarted){return}
        
        if guesture.state == UIGestureRecognizer.State.began {
            let value = wordView.removeAll()
        
            addScore(scoreAdd:0, energyAdd: -Double(value) , display: true)
 
            
        }
    }
    

    func addFreeLetter(x : CGFloat =  -1, y : CGFloat = -1){
        
        let letter = LetterView (boardFrame: boardView.frame)
        
        if (x != -1){
            letter.updateCoordinates(x:x, y: y, speed: 1.4)
        }
        
        if !letter.isSpecial{
            letter.addTarget(self, action:   #selector(MainController.letterClicked(_:)),
                             for: .touchDown)}
            
        else{
            letter.addTarget(self, action: #selector(MainController.specialActivated(_:)),
                             for: .touchDown)}
        
        
        
        self.view.addSubview(letter)
        self.view.bringSubviewToFront(letter)
        
        freeLetters.append(letter)
    }
    

    
    func run(){
        
        var counter = 0
        
        // clean up the game
        
        energy = INIT_ENERGY
        score  = 0
        timeElapsed = 0
        gameState = GameState.GameStarted
        
        backspaceButton.isUserInteractionEnabled = true
        lblScore.text  = "Score:  \(score)"
        lblEnergy.text = "Energy: \((Int(energy)))"
        
        
        timer.invalidate()
        
        
        _ = wordView.removeAll()
        
        lblStatus.isHidden = true
        lblEnergyAdd.isHidden = true
        lblScoreAdd.isHidden = true
        
        for letter in freeLetters{
            letter.removeFromSuperview()
        }
        freeLetters.removeAll()
        
        
        displayStatus(status:"Welcome", dismiss: true)
        
        // end of cleanup
        
        
        for _ in 0..<NUM_CHARS{
            addFreeLetter()
        }
        
        
        timer = Timer.scheduledTimer(timeInterval:TIME_INT, target:self, selector:
            #selector(MainController.updateState),
            userInfo: nil, repeats: true)
        
        
        counter += 1
        
        
    }
    
    @objc
    func updateState() {
        
        if (gameState != GameState.GameStarted){
            return
        }
        
        specialClock -= TIME_INT
        p(toPrint:specialClock)
        if (energy <= 0){
            gameOver()
            return
            
        }
        
        
        timeElapsed += 1
        addScore(scoreAdd:0, energyAdd:(-TIME_CONST - power(num:timeElapsed) * TIME_MULT),display: false)
        //print("\(-TIME_CONST - power(timeElapsed) * TIME_MULT)")
        
        if (energy > LOW_ENERGY_MARKER){

            lblEnergy.textColor = defaultTxtColor
            
            
        }
        else {
         lblEnergy.textColor = COLOR_PLATE[9 - Int( energy*(9/LOW_ENERGY_MARKER))]
   
        }
        
        for i in (0..<freeLetters.count).reversed(){
            
            let l = freeLetters[i]
            
            let (dx, dy) = l.velocity
            
            var x = l.center.x + CGFloat(dx)
            var y = l.center.y + CGFloat(dy)
            
            
            if (l.isAged()){
                if !boardView.superview!.frame.intersects(l.frame){
                //CGRect.intersects(boardView.superview!.frame, l.frame){
        
                    l.removeFromSuperview()
                    freeLetters.remove(at: i)
                    if (freeLetters.count < NUM_CHARS) || (specialClock > 0){
                        
                        addFreeLetter()
                        
                    }
                    
                    
                }
                
            }
            else {
                
                if (x > boardView.frame.maxX) {
                    
                    if (l.incrementAge()){
                        x = boardView.frame.maxX
                        l.velocity = (-dx, dy)
                    }
                }
                else if (x < boardView.frame.minX) {
                    
                    if (l.incrementAge()){
                        
                        x = boardView.frame.minX
                        l.velocity = (-dx, dy)
                    }
                }
                if (y > boardView.frame.maxY) {
                    if (l.incrementAge()) {
                        
                        y = boardView.frame.maxY
                        l.velocity = (dx, -dy)
                    }
                }
                else if (y < boardView.frame.minY) {
                    if (l.incrementAge()){
                        
                        y = boardView.frame.minY
                        l.velocity = (dx, -dy)
                    }
                }
            }
            l.center = CGPoint(x:x, y:y)
            l.rotationAngle = l.rotationAngle + l.angularVelocity
            l.rotate(angle:l.rotationAngle)
            
            
        }
    }
    
    func gameOver(){
        
        timer.invalidate()
        
        displayStatus(status:"Game Over", dismiss : false)
        
        handleHighScore()
        
        gameState = GameState.GameOver
        
        for letter in freeLetters{
            letter.removeFromSuperview()
        }
        
        freeLetters.removeAll()
        
        backspaceButton.isUserInteractionEnabled = false
        
    
    }
    
    func handleHighScore(){
        
        let len = highScores.count
        if len < 10{
            var newArray = [Int]()
            var i = 0
            while (i < len) && (score < highScores[i]) {
                newArray.append(highScores[i])
                i += 1
            }
            newArray.append(score)
            while i < (len){
                newArray.append(highScores[i])
                i += 1
                
            }
            
            defaults.set(newArray,forKey: "HighScores")
            
            highScores = newArray
            
            highScore = highScores[0]
            
            
        }
        
        else if score > highScores.last!{
            var newArray = [Int]()
            var i = 0
            while(score < highScores[i]){
                newArray.append(highScores[i])
                i += 1
            }
            newArray.append(score)
            while i < (9){
                newArray.append(highScores[i])
                i += 1
                
            }
            defaults.set(newArray, forKey: "HighScores")
            
            highScores = newArray
            
            highScore = highScores[0]
        }
        
        print("\(highScores)")
     
            
    }

    
    func displayStatus(status : String, dismiss : Bool = true){
        
        
        lblStatus.isHidden = false
        
        self.view.bringSubviewToFront(lblStatus)
        
        lblStatus.transform = CGAffineTransform(scaleX:0.5, y:0.5)
        self.lblStatus.text = status
        
        UIView.animate(withDuration:1, animations: {
            self.lblStatus.transform = CGAffineTransform (scaleX:1.5, y:1.5)
            }, completion: { (i : Bool) in
                if (dismiss){self.lblStatus.isHidden = true}
        })
        
        
    }

    
    func addScore(scoreAdd : Int, energyAdd : Double, display : Bool = false){
        
        
        score  += scoreAdd
        energy += energyAdd
        lblScore.text  = "Score:  \(score)"
        lblEnergy.text = "Energy: \((Int(energy)))"
        
        
        
        if (!display){
            return
        }
        
        
        if(scoreAdd > 0){
            displayStatus(status:"Score: +\(scoreAdd)", dismiss: true)
        }
        else if (energyAdd < 0){
            displayStatus(status:"Energy: \(Int(energyAdd))", dismiss: true)
        }
    }
    
    
    func formatButtons(){
        backspaceButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        
        //buttonBackspace.backgroundColor = UIColor.init(red: 200.0/255.0, green: 0, blue: 200/255.0, alpha: 1)
        
        
        backspaceButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        
        backspaceButton.layer.cornerRadius = 3.0;
        
        backspaceButton.layer.borderWidth = 0.0; //was 2.0
        backspaceButton.layer.borderColor = UIColor.white.cgColor
        
        //backspaceButton.layer.shadowColor = UIColor(red: 100/255.0, green: 0, blue: 0, alpha: 1).CGColor
        
        backspaceButton.layer.shadowOpacity = 1.0
        backspaceButton.layer.shadowRadius = 0.0 // was 1
        backspaceButton.layer.shadowOffset = CGSize(width:0, height:3);
        
        
        /// play button
        
        //playButton.setTitle("+", forState: UIControlState.Normal)
        
        //playButton.backgroundColor = UIColor.init(red: 200.0/255.0, green: 0, blue: 0, alpha: 1)
        
        playButton.setBackgroundImage(UIImage(named: "Submit"), for: .normal)
        
        
        playButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        
        playButton.layer.cornerRadius = 3.0;
        
        playButton.layer.borderWidth = 0.0;
        playButton.layer.borderColor = UIColor.white.cgColor
        
        playButton.layer.shadowColor = UIColor.white.cgColor
        
        playButton.layer.shadowOpacity = 1.0
        playButton.layer.shadowRadius = 1.0
        playButton.layer.shadowOffset = CGSize(width:0, height:3);
        
        
        playButton.clipsToBounds = true
        
        
    }
    func getHighScores() -> [Int]{
        return highScores
        
        
    }
    
    func setHighScores(hs : [Int]){
        highScores = hs
    }
    
    
    func power(num : Double) -> Double{
        
        return pow(num, EXPONENT)
    }

    
    func activateSpawner(button: LetterView){
        
        let frame = button.frame
        specialClock = DUR_SPAWNER
        for _ in freeLetters.count..<SPAWNER_CHARS{
            addFreeLetter(x:frame.midX, y: frame.midY)
        }
     
        UIView.animate(withDuration:0.5, animations: {
            
            button.addEmitter()
            button.transform = CGAffineTransform(scaleX:0.1, y:0.1)
            button.backgroundColor = UIColor.blue
            }, completion: { (i : Bool) in
                button.removeFromSuperview()
                
        })
        
    }
    
    
    func sonicBoom(button: LetterView){
        
        var toAdd = 0
        button.removeFromSuperview()
        
        for letter in freeLetters{
            toAdd += letter.letterValue
            letter.removeFromSuperview()
        }
        
        freeLetters.removeAll()
        
        let lettersToSpawn = ((specialClock > 0) ? NUM_CHARS : SPAWNER_CHARS)
        
        for _ in 0..<lettersToSpawn{
            addFreeLetter()
        }
        addScore(scoreAdd:toAdd, energyAdd: Double(toAdd))
        
    }

}
