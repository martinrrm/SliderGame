//
//  GameViewController.swift
//  Cable_Grid
//
//  Created by Alumno on 3/25/19.
//  Copyright © 2019 Throwaway Studios. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var imgG1: CableImageView!
    @IBOutlet weak var imgG2: CableImageView!
    @IBOutlet weak var imgG3: CableImageView!
    @IBOutlet weak var imgG4: CableImageView!
    @IBOutlet weak var imgG5: CableImageView!
    @IBOutlet weak var imgG6: CableImageView!
    @IBOutlet weak var imgG7: CableImageView!
    @IBOutlet weak var imgG8: CableImageView!
    @IBOutlet weak var imgG9: CableImageView!
    var gameOver = false
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let tapGesture1 = UITapGestureRecognizer()
    let tapGesture2 = UITapGestureRecognizer()
    let tapGesture3 = UITapGestureRecognizer()
    let tapGesture4 = UITapGestureRecognizer()
    let tapGesture5 = UITapGestureRecognizer()
    let tapGesture6 = UITapGestureRecognizer()
    let tapGesture7 = UITapGestureRecognizer()
    let tapGesture8 = UITapGestureRecognizer()
    let tapGesture9 = UITapGestureRecognizer()
    
    var levels = [CableLevelData]()
    var indexOfLevel = 0
    
    var arrayUIImages : [CableImageView] = []
    
    var seconds = 30
    
    var timer = Timer()
    
    //This function gives a random rotation to each image in the grid
    func randomizePositions() -> Void {
        for view in arrayUIImages {
            let value = Int.random(in: 0 ... 3)
            view.Variable = value
            view.transform = CGAffineTransform(rotationAngle: ((CGFloat(value) * 90.0 * 3.1416) / 180))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start timer of game
        runTimer()
        
        //Define game scene an background color
        if let view = self.view as! SKView? {
            let scene = SKScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
            scene.scaleMode = .aspectFit    // define the scaleMode for this scene
            scene.backgroundColor = SKColor(displayP3Red: 0.237, green: 0.019, blue: 0.177, alpha: 1)  // HERE: background color

            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        
        }
        
        //Add image elements to array for later reference
        arrayUIImages.append(imgG1)
        arrayUIImages.append(imgG2)
        arrayUIImages.append(imgG3)
        arrayUIImages.append(imgG4)
        arrayUIImages.append(imgG5)
        arrayUIImages.append(imgG6)
        arrayUIImages.append(imgG7)
        arrayUIImages.append(imgG8)
        arrayUIImages.append(imgG9)
        
        //Load levels from plist
        loadlevels()
        
        //Select random level from list
        indexOfLevel = Int.random(in: 0...(levels.count - 1))
        
        
        //Add images to StoryBoard from levels list
        for (index, uiImage) in arrayUIImages.enumerated() {
            uiImage.image = UIImage(named: levels[indexOfLevel].arrayImageNames[index])
            uiImage.isUserInteractionEnabled = true
        }
        
        //randomize the rotation of images
        randomizePositions()
        
        //Tasp gesture for each image int the grid
        tapGesture1.addTarget(self, action: #selector(rotateImage))
        tapGesture2.addTarget(self, action: #selector(rotateImage))
        tapGesture3.addTarget(self, action: #selector(rotateImage))
        tapGesture4.addTarget(self, action: #selector(rotateImage))
        tapGesture5.addTarget(self, action: #selector(rotateImage))
        tapGesture6.addTarget(self, action: #selector(rotateImage))
        tapGesture7.addTarget(self, action: #selector(rotateImage))
        tapGesture8.addTarget(self, action: #selector(rotateImage))
        tapGesture9.addTarget(self, action: #selector(rotateImage))
        
        imgG1.addGestureRecognizer(tapGesture1)
        imgG2.addGestureRecognizer(tapGesture2)
        imgG3.addGestureRecognizer(tapGesture3)
        imgG4.addGestureRecognizer(tapGesture4)
        imgG5.addGestureRecognizer(tapGesture5)
        imgG6.addGestureRecognizer(tapGesture6)
        imgG7.addGestureRecognizer(tapGesture7)
        imgG8.addGestureRecognizer(tapGesture8)
        imgG9.addGestureRecognizer(tapGesture9)
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    //Function to retrieve levels from plist
    func retrieveLevels() -> [CableLevelData]? {
        do {
            let data = try Data.init(contentsOf: CableLevelData.url)
            print(CableLevelData.archiveURL)
            let lvlTemp = try PropertyListDecoder().decode([CableLevelData].self, from: data)
            return lvlTemp
        } catch {
            print("Error reading or decoding file")
            return nil
        }
    }
    
    //Function that coles decoder function
    func loadlevels() {
        levels.removeAll()
        guard let lvlTmp = retrieveLevels() else { return }
        
        levels = lvlTmp
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //Checks grid for the positions of the images
    func checkGrid() -> Void {
        //Verify with level data that position is correct
        for (index, pos) in levels[indexOfLevel].arrayPositions.enumerated() {
            if(levels[indexOfLevel].arrayImageNames[pos] == "Linea Cable-1") {
                if(abs(Double(arrayUIImages[pos].Variable).remainder(dividingBy: 2)) != abs(Double(levels[indexOfLevel].arrayAnswers[index]).remainder(dividingBy: 2))) {
                    return
                }
            } else {
                if(arrayUIImages[pos].Variable != levels[indexOfLevel].arrayAnswers[index]){
                    return
                }
            }
        }
        //Stop timer and end game
        timer.invalidate()
        let alert = UIAlertController(title: "You Won", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { actions in
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Rotate image view
    @IBAction func rotateImage(_ sender: UITapGestureRecognizer) {
        let oneRadian:CGFloat = (1.0 * 90.0 * 3.1416) / 180
        var radians = CGFloat(atan2f(Float((sender.view?.transform.b)!), Float((sender.view?.transform.a)!)))
        if(radians >= oneRadian * 3) {
            radians = 0.0
        } else {
            radians = radians + oneRadian
        }
        UIView.animate(withDuration: 0.5, animations: {
            sender.view?.transform = CGAffineTransform(rotationAngle: radians)
        })
        
        let myImageView = sender.view as! CableImageView
        myImageView.Variable += 1
        if(myImageView.Variable == 4) {
            myImageView.Variable = 0
        }
        checkGrid()
        
        
    }
    
    //starts the timer of the game
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    //Updates the displayed variable of the timer and ends the game when time is over
    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = "\(seconds)"
        if(seconds == 0) {
            timer.invalidate()
            let alert = UIAlertController(title: "Game Over", message: "You ran out of time.", preferredStyle: .alert)
            gameOver = true
            //self.view?.window?.rootViewController?.performSegue(withIdentifier: "GO", sender: self)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { actions in
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if gameOver == false {
            let viewPopOver = segue.destination as! CableInstViewController
            viewPopOver.popoverPresentationController!.delegate = self
            timer.invalidate()
        }
        else {
            let vc = segue.destination as! SliderViewController
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        runTimer()
    }
    
}
