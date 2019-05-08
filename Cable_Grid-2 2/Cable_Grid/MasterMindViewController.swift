//
//  MasterMindViewController.swift
//  Cable_Grid
//
//  Created by Martin Rodrigo Ruiz Mares on 5/1/19.
//  Copyright © 2019 Throwaway Studios. All rights reserved.
//

import UIKit

class MasterMindViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var currentTry : Int = 0
    
    var buttonColors = [-1,-1,-1,-1]
    var buttonsSolucion = [0,1,2,3]
    var numIntentos = 0
    
    // Colores del juego
    let colors = [0: UIColor.blue, 1: UIColor.green, 2: UIColor.black, 3: UIColor.orange, 4: UIColor.yellow, 5: UIColor.cyan]
    
    // Para animacion
    let animator = CAAnimation()
    var viewsArray = [UIView]()
    var solutions : Int = 0
    var viewsOptions = [UIView]()
    var tagSolucion = 4
    var tagSolucionController = 4
    var currentRow:Int!
    var tag : Int = 0
    var win = false
    var gameOver = false
    
    @IBOutlet weak var btnSol0: UIView!
    @IBOutlet weak var btnSol1: UIView!
    @IBOutlet weak var btnSol2: UIView!
    @IBOutlet weak var btnSol3: UIView!
    
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!
    @IBOutlet weak var viewFive: UIView!
    @IBOutlet weak var viewSix: UIView!
    
    @IBOutlet weak var One: UIView!
    @IBOutlet weak var Two: UIView!
    @IBOutlet weak var Three: UIView!
    @IBOutlet weak var Four: UIView!
    @IBOutlet weak var Five: UIView!
    @IBOutlet weak var Six: UIView!
    @IBOutlet weak var Seven: UIView!
    @IBOutlet weak var Eigth: UIView!
    @IBOutlet weak var Nine: UIView!
    @IBOutlet weak var Ten: UIView!
    @IBOutlet weak var Eleven: UIView!
    @IBOutlet weak var Twelve: UIView!
    @IBOutlet weak var Trece: UIView!
    @IBOutlet weak var Catorce: UIView!
    @IBOutlet weak var Quince: UIView!
    @IBOutlet weak var DiezSeis: UIView!
    @IBOutlet weak var DiezSiete: UIView!
    @IBOutlet weak var DiezOcho: UIView!
    @IBOutlet weak var DiezNueve: UIView!
    @IBOutlet weak var Veinte: UIView!
    @IBOutlet weak var VeinteUno: UIView!
    @IBOutlet weak var VeinteDos: UIView!
    @IBOutlet weak var VeinteTres: UIView!
    @IBOutlet weak var VeinteCuatro: UIView!
    
    @IBOutlet weak var btnTest: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTry = 52
        currentRow = 8
        
        viewsOptions.append(One)
        viewsOptions.append(Two)
        viewsOptions.append(Three)
        viewsOptions.append(Four)
        viewsOptions.append(Five)
        viewsOptions.append(Six)
        viewsOptions.append(Seven)
        viewsOptions.append(Eigth)
        viewsOptions.append(Nine)
        viewsOptions.append(Ten)
        viewsOptions.append(Eleven)
        viewsOptions.append(Twelve)
        viewsOptions.append(Trece)
        viewsOptions.append(Catorce)
        viewsOptions.append(Quince)
        viewsOptions.append(DiezSeis)
        viewsOptions.append(DiezSiete)
        viewsOptions.append(DiezOcho)
        viewsOptions.append(DiezNueve)
        viewsOptions.append(Veinte)
        viewsOptions.append(VeinteUno)
        viewsOptions.append(VeinteDos)
        viewsOptions.append(VeinteTres)
        viewsOptions.append(VeinteCuatro)

        
        viewOne.translatesAutoresizingMaskIntoConstraints = false
        viewOne.backgroundColor = UIColor.blue
        
        viewTwo.translatesAutoresizingMaskIntoConstraints = false
        viewTwo.backgroundColor = UIColor.green
        
        viewThree.translatesAutoresizingMaskIntoConstraints = false
        viewThree.backgroundColor = UIColor.black
        
        viewFour.translatesAutoresizingMaskIntoConstraints = false
        viewFour.backgroundColor = UIColor.orange
        
        viewFive.translatesAutoresizingMaskIntoConstraints = false
        viewFive.backgroundColor = UIColor.yellow
        
        viewSix.translatesAutoresizingMaskIntoConstraints = false
        viewSix.backgroundColor = UIColor.cyan
        
        addViewHandler(viewBottom: viewOne)
        addViewHandler(viewBottom: viewTwo)
        addViewHandler(viewBottom: viewThree)
        addViewHandler(viewBottom: viewFour)
        addViewHandler(viewBottom: viewFive)
        addViewHandler(viewBottom: viewSix)
        
        startGame()
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        if let viewBottom = recognizer.view {
            if recognizer.state == .began{
                let gameCard = UIView()
                gameCard.translatesAutoresizingMaskIntoConstraints = false
                gameCard.backgroundColor = viewBottom.backgroundColor
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveObject(gesture:)))
                gameCard.addGestureRecognizer(panGesture)
                self.view.addSubview(gameCard)
                
                gameCard.leftAnchor.constraint(equalTo: viewBottom.leftAnchor, constant: 0).isActive = true
                gameCard.rightAnchor.constraint(equalTo: viewBottom.rightAnchor, constant: 0).isActive = true
                gameCard.topAnchor.constraint(equalTo: viewBottom.topAnchor, constant: 0).isActive = true
                gameCard.bottomAnchor.constraint(equalTo: viewBottom.bottomAnchor, constant: 0).isActive = true
                
                viewsArray.append(gameCard)
            }
        }
    }
    
    // Mover los colores y agregar uno nuevo a la cola
    @objc func moveObject(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.view)
        if let viewA = gesture.view {
            viewA.center = CGPoint(x:viewA.center.x + translation.x,
                                   y:viewA.center.y + translation.y)
        }
        if gesture.state == .ended {
            print("Termino de moverse")
            addViewHandler(viewBottom: self.view.viewWithTag(gesture.view!.tag)!)
            for viewS in viewsOptions {
                if let viewA = gesture.view{
                    let r1 = viewA.superview!.convert(viewA.frame, to: nil)
                    let r2 = viewS.superview!.convert(viewS.frame, to: nil)
                    print(viewA.frame)
                    print(viewS.frame)
                    if(r1.intersects(r2) && viewS.tag < currentRow && viewS.tag >= currentRow - 8){
                        print("Se intersectan")
                        viewS.backgroundColor = viewA.backgroundColor
                        break
                    }
                }
            }
            gesture.view!.removeFromSuperview()
        }
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }
    
    // Funcion para agregar una view
    func addViewHandler(viewBottom:UIView){
        let gameCard = UIView()
        gameCard.translatesAutoresizingMaskIntoConstraints = false
        gameCard.backgroundColor = viewBottom.backgroundColor
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveObject(gesture:)))
        
        gameCard.addGestureRecognizer(panGesture)
        
        self.view.addSubview(gameCard)
        
        gameCard.leftAnchor.constraint(equalTo: viewBottom.leftAnchor, constant: 0).isActive = true
        gameCard.rightAnchor.constraint(equalTo: viewBottom.rightAnchor, constant: 0).isActive = true
        gameCard.topAnchor.constraint(equalTo: viewBottom.topAnchor, constant: 0).isActive = true
        gameCard.bottomAnchor.constraint(equalTo: viewBottom.bottomAnchor, constant: 0).isActive = true
        gameCard.tag = viewBottom.tag
        viewsArray.append(gameCard)
    }
    
    // Generador de la respuesta
    func startGame() -> Void {
        // answer 1
        var number = Int.random(in : 0...5)
        btnSol0.backgroundColor = colors[number]
        buttonsSolucion[0] = number
        // answer 2
        number = Int.random(in : 0...5)
        btnSol1.backgroundColor = colors[number]
        buttonsSolucion[1] = number
        while btnSol1.backgroundColor ==
            btnSol0.backgroundColor {
            number = Int.random(in : 0...5)
            btnSol1.backgroundColor = colors[number]
            buttonsSolucion[1] = number
        }
        // answer 3
        number = Int.random(in : 0...5)
        btnSol2.backgroundColor = colors[number]
        buttonsSolucion[2] = number
        while btnSol2.backgroundColor == btnSol0.backgroundColor || btnSol2.backgroundColor == btnSol1.backgroundColor {
            number = Int.random(in : 0...5)
            btnSol2.backgroundColor = colors[number]
            buttonsSolucion[2] = number
        }
        // answer 4
        number = Int.random(in : 0...5)
        btnSol3.backgroundColor = colors[number]
        buttonsSolucion[3] = number
        while btnSol3.backgroundColor == btnSol0.backgroundColor || btnSol3.backgroundColor == btnSol1.backgroundColor || btnSol3.backgroundColor == btnSol2.backgroundColor {
            number = Int.random(in : 0...5)
            btnSol3.backgroundColor = colors[number]
            buttonsSolucion[3] = number
        }
        print("-----------------------------------------------------------------")
        print(buttonsSolucion)
    }
    
    func newGuess(aciertosPocision: Int, aciertosColor: Int) -> Void {
        print(aciertosPocision)
        print(aciertosColor)
        var i = 0
        tagSolucion = tagSolucionController
        while i < aciertosPocision {
            view.viewWithTag(tagSolucion)?.backgroundColor = UIColor.red
            tagSolucion+=1
            i = i + 1
        }
        while i < aciertosColor + aciertosPocision {
            view.viewWithTag(tagSolucion)?.backgroundColor = UIColor.white
            tagSolucion+=1
            i = i + 1
        }
        
        tagSolucionController+=8
    }
    
    @IBAction func test(_ sender: Any) {
//        currentRow = currentRow + 8
//        view.viewWithTag(currentTry)?.isHidden = false
//        currentTry = currentTry + 1
//        view.viewWithTag(currentTry)?.isHidden = false
//        currentTry = currentTry +  1
//        if(btnTest.currentTitle == "Game Over"){
//            self.view?.window?.rootViewController?.performSegue(withIdentifier: "GO", sender: self)
//        }
        print(tag)
        for i in 0...5{
            if(view.viewWithTag(tag)?.backgroundColor == colors[i]){
                buttonColors[0] = i
                break
            }
            buttonColors[0] = -1
        }
        
        for i in 0...5{
            if(view.viewWithTag(tag+1)?.backgroundColor == colors[i]){
                buttonColors[1] = i
                break
            }
            buttonColors[1] = -1
        }
        for i in 0...5{
            if(view.viewWithTag(tag+2)?.backgroundColor == colors[i]){
                buttonColors[2] = i
                break
            }
            buttonColors[2] = -1
        }
        for i in 0...5{
            if(view.viewWithTag(tag+3)?.backgroundColor == colors[i]){
                buttonColors[3] = i
                break
            }
            buttonColors[3] = -1
        }
        
        var repetidos = false
        var posicionBien = 0, colorBien = 0
        var i = 0, j = 0
        while i < 4 {
            print(buttonColors[i], buttonsSolucion[i])
            j = 0
            while j < 4 {
                if (i == j && buttonColors[i] == buttonsSolucion[j]) {
                    posicionBien = posicionBien + 1
                } else if (buttonColors[i] == buttonsSolucion[j]) {
                    colorBien = colorBien + 1
                }
                if(i != j && buttonColors[i] == buttonColors[j]) {
                    repetidos = true
                    break
                }
                j = j + 1
            }
            i = i + 1
        }
        if(win == true){
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        if repetidos {
            let alert = UIAlertController(title: "Alerta", message: "No se pueden tener colores repetidos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            currentRow = currentRow + 8
            view.viewWithTag(currentTry)?.isHidden = false
            currentTry = currentTry + 1
            view.viewWithTag(currentTry)?.isHidden = false
            currentTry = currentTry +  1
            numIntentos = numIntentos + 1
            tag+=8
            newGuess(aciertosPocision: posicionBien, aciertosColor: colorBien)
            if (posicionBien == 4) {
                let alertWin = UIAlertController(title: "Ganaste en " + String(numIntentos) + " intento(s)", message: nil, preferredStyle: .alert)
                alertWin.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertWin, animated: true, completion: nil)
                self.win = true
                self.btnTest.setTitle("Back", for: .normal)
            } else if (numIntentos > 5) {
                let alertLose = UIAlertController(title: "Se te acabaron los intentos", message:"mejor suerte a la proxima", preferredStyle: .alert)
                self.gameOver = true
                alertLose.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertLose, animated: true, completion: nil)
                self.btnTest.setTitle("Game Over", for: .normal)
                self.view!.window!.rootViewController!.dismiss(animated: true, completion: nil)
            }
        }
        print(buttonColors)
        
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let viewPopOver = segue.destination as! MasterMindInstViewController
            viewPopOver.popoverPresentationController!.delegate = self

    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}
