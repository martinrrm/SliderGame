//
//  SecondViewControllerSlider.swift
//  cardSlider_PF01
//
//  Created by Martin Rodrigo Ruiz Mares on 3/24/19.
//  Copyright © 2019 Martin Rodrigo Ruiz Mares. All rights reserved.
//

import UIKit
import GameplayKit

class SliderViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    static let url = Bundle.main.url(forResource: "Events", withExtension: "plist")!
    
    
    @IBOutlet weak var lblVida: UILabel!
    @IBOutlet weak var lblCombustible: UILabel!
    @IBOutlet weak var lblDinero: UILabel!
    @IBOutlet weak var lblNave: UILabel!
    
    // Variables para los labels
    var vida = 25
    var combustible = 25
    var dinero = 25
    var nave = 25
    var inst = false

    // Crear un arreglo de views que serán las cartas
    var viewsArray = [UIView]()
    var eventsArray = [Events]()
    var index:Int!
    var divisor:CGFloat!
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let puntuation:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .brown
        return view
    }()
    
    let modalView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblVida.text = String(vida) + "%"
        lblCombustible.text = String(combustible) + "%"
        lblDinero.text = String(dinero) + "%"
        lblNave.text = String(nave) + "%"
        
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        divisor = (view.frame.width / 2) / 0.61
        
        let gameCard = UIView()
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        textView.center = CGPoint(x: 150, y: 100)
        textView.textAlignment = .center
        textView.text = "To be continued..."
        textView.font = UIFont.boldSystemFont(ofSize: 16.0)
        textView.sizeToFit()
        textView.isHidden = true
        textView.tag = 998
        textView.isEditable = false
        //textView.leftAnchor.constraint(equalToSystemSpacingAfter: gameCard.leftAnchor, multiplier: 1)
        //textView.rightAnchor.constraint(equalToSystemSpacingAfter: gameCard.rightAnchor, multiplier: 5)
        textView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        /*
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 350, height: 50))
        label.center = CGPoint(x: 180, y: 200)
        label.textAlignment = .center
        label.text = "To be continued..."
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.numberOfLines = 0
        label.sizeToFit()
        label.isHidden = true
        label.tag = 999
         */
        gameCard.addSubview(textView)
        gameCard.translatesAutoresizingMaskIntoConstraints = false
        gameCard.backgroundColor = randomColor()
        view.addSubview(gameCard)
        gameCard.tag = 1000
        gameCard.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        gameCard.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        gameCard.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        gameCard.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        viewsArray.append(gameCard)
        
        do {
            let data = try Data.init(contentsOf: SliderViewController.url)
            var aux = try PropertyListDecoder().decode([Events].self, from: data)
            aux.reverse()
            for i in 0 ... aux.count - 1{
                let gameCard = UIView()
                let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
                textView.center = CGPoint(x: 180, y: 200)
                textView.textAlignment = .center
                textView.text = aux[i].Description
                textView.font = UIFont.boldSystemFont(ofSize: 16.0)
                textView.sizeToFit()
                textView.isHidden = true
                textView.tag = 998
                textView.isEditable = false
                textView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
                
                /*
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 350, height: 50))
                label.center = CGPoint(x: 180, y: 200)
                label.textAlignment = .center
                label.text = aux[i].Description
                label.font = UIFont.boldSystemFont(ofSize: 16.0)
                label.numberOfLines = 0
                label.sizeToFit()
                label.isHidden = true
                label.tag = 999
                 */
                gameCard.addSubview(textView)
                // Constraints
                //let xContraint = NSLayoutConstraint(item: textView, attribute: .centerX, relatedBy: .equal, toItem: gameCard, attribute: .centerX, multiplier: 1, constant: 0)
                //let yContraint = NSLayoutConstraint(item: textView, attribute: .centerY, relatedBy: .equal, toItem: gameCard, attribute: .centerY, multiplier: 1, constant: 0)
                //NSLayoutConstraint.activate([xContraint, yContraint])
                

                
                
                gameCard.translatesAutoresizingMaskIntoConstraints = false
                gameCard.backgroundColor = randomColor()
                gameCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture:))))
                view.addSubview(gameCard)
                gameCard.tag = i
                gameCard.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
                gameCard.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
                gameCard.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
                gameCard.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
                viewsArray.append(gameCard)
                textView.centerXAnchor.constraint(equalTo: gameCard.centerXAnchor).isActive = true
                textView.centerYAnchor.constraint(equalTo: gameCard.centerYAnchor).isActive = true
                eventsArray = aux
            }

        } catch {
            print("Error reading or decoding file")
        }
        
        self.index = viewsArray.count - 1
        
        UIView.transition(with: viewsArray.last!, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: nil, completion: nil)
        viewsArray.last?.viewWithTag(998)?.isHidden = false
        
        view.addSubview(modalView)
        modalView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        modalView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        modalView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        modalView.backgroundColor = randomColor()
        modalView.isHidden = true
        
    }
    
    func setView(view: UIView, event: Events, option: Int) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 350, height: 50))
        view.addSubview(label)
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        label.textAlignment = .center
        label.text = event.Feedback[option]
        label.numberOfLines = 0
        label.sizeToFit()
        label.isHidden = false
        label.tag = 998
        UIView.transition(with: view, duration: 1, options: .transitionCrossDissolve, animations: {
            view.isHidden = false
        }, completion: {(finished:Bool) in
            sleep(4)
            UIView.transition(with: view, duration: 2, options: .showHideTransitionViews, animations: {
                view.isHidden = true
            }, completion: {(finished:Bool) in
                self.viewsArray.removeLast()
                self.eventsArray.removeLast()
                
                UIView.transition(with: self.viewsArray.last!, duration: 1.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: nil, completion: nil)
                self.viewsArray.last?.viewWithTag(998)?.isHidden = false
                view.viewWithTag(998)?.removeFromSuperview()
            })
        })
    }
    
    func updateCard(eventsArray : [Events], opcion : Bool){
        let event = eventsArray.last!
        let answer : Int
        if(opcion == true){
            answer = 0
            if(event.Key == 0){
                vida += Int(event.Value)
            }
            else if(event.Key == 1){
                combustible += Int(event.Value)
            }
            else if(event.Key == 2){
                dinero += Int(event.Value)
            }
            else if(event.Key == 3){
                nave += Int(event.Value)
            }
        } else if(opcion == false){
            answer = 2
        } else {
            answer = 3
        }
        
        if(vida <= 0){
            let number = Int.random(in: 0 ..< 3)
            print(number)
            print("----------------")
            self.view?.window?.rootViewController?.performSegue(withIdentifier: String(number), sender: self)
        }
        if(combustible <= 0){
            let number = Int.random(in: 0 ..< 3)
            print(number)
            print("----------------")
            self.view?.window?.rootViewController?.performSegue(withIdentifier: String(number), sender: self)
        }
        if(dinero <= 0){
            let number = Int.random(in: 0 ..< 3)
            print(number)
            print("----------------")
            self.view?.window?.rootViewController?.performSegue(withIdentifier: String(number), sender: self)
        }
        if(nave <= 0){
            let number = Int.random(in: 0 ..< 3)
            print(number)
            print("----------------")
            self.view?.window?.rootViewController?.performSegue(withIdentifier: String(number), sender: self)
        }
        
        setView(view: modalView, event: event, option: answer)
        
        let animation: CATransition = CATransition()
        animation.duration = 1.0
        animation.type = CATransitionType.fade
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        lblVida.layer.add(animation, forKey: "changeTextTransition")
        lblCombustible.layer.add(animation, forKey: "changeTextTransition")
        lblDinero.layer.add(animation, forKey: "changeTextTransition")
        lblNave.layer.add(animation, forKey: "changeTextTransition")
        
        lblVida.text = String(vida) + "%"
        lblCombustible.text = String(combustible) + "%"
        lblDinero.text = String(dinero) + "%"
        lblNave.text = String(nave) + "%"
    }
    
    @objc func panGesture(gesture:UIPanGestureRecognizer){
        let card = gesture.view
        let point = gesture.translation(in: self.view)
        UIView.animate(withDuration: 0.2) {
            card?.center = CGPoint(x: self.view.center.x + point.x, y: self.view.center.y + point.y)
        }
        
        let xFromCenter = (card?.center.x)! - view.center.x
        card?.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
        let floatValue:CGFloat = 75
        
        if gesture.state == .ended{
            // Izquierda
            if (card?.center.x)! < floatValue{
                //move left
                self.index = self.index - 1
                UIView.animate(withDuration: 0.2) {
                    card?.center = CGPoint(x: (card?.center.x)! - 200, y: self.view.center.y + 75)
                    card?.alpha = 0
                }
                updateCard(eventsArray: eventsArray, opcion : true)
               //self.performSegue(withIdentifier: "1", sender: self)
                //sel.view?.window?.rootViewController?.performSegue(withIdentifier: "2", sender: self)
                return
            }
                
                // Derecha
            else if (card?.center.x)! > (view.frame.width - 75){
                //move right
                self.index = self.index - 1
                UIView.animate(withDuration: 0.2) {
                    card?.center = CGPoint(x: (card?.center.x)! + 200, y: self.view.center.y)
                    card?.alpha = 0
                }
                //print("Se movio a la derecha")
                updateCard(eventsArray : eventsArray, opcion : false)
                
                //                viewsArray.removeLast()
                //                eventsArray.removeLast()
                //                UIView.transition(with: viewsArray.last!, duration: 1.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: nil, completion: nil)
                //                viewsArray.last?.viewWithTag(999)?.isHidden = false
                return
            }
            
            // Animacion
            UIView.animate(withDuration: 0.2) {
                card?.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
                card?.transform = CGAffineTransform.identity
            }
            
        }
    }
    
    func randomColor()->UIColor{
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        lblVida.text = String(vida) + "%"
        lblCombustible.text = String(combustible) + "%"
        lblDinero.text = String(dinero) + "%"
        lblNave.text = String(nave) + "%"
        
        if inst == true{
            let viewPopOver = segue.destination as! SliderInstViewController
            viewPopOver.popoverPresentationController!.delegate = self
        } else {
            vida+=20
            combustible+=20
            dinero+=20
            nave+=20
        }
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
    
    @IBAction func inst(_ sender: Any) {
        inst = true
    }
    
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        inst  = false
    }
    
}
