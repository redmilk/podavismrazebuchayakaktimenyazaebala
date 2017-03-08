//
//  QuestionViewController.swift
//  Guess the Fighter, Угадай Бойца
//
//  Created by Artem on 11/14/16.
//  Copyright © 2016 piqapp. All rights reserved.

///FONTS///

// Avenir-LightOblique  AvenirNext-UltraLight Didot-Bold HelveticaNeue-UltraLight PingFangHK-Ultralight PingFangTC-Thin


import UIKit

func setupGradient(_ layerAttachTo: CALayer, frame: CGRect, gradient: CAGradientLayer, colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint, zPosition: Float) {
    
    gradient.frame = frame
    gradient.colors = colors
    gradient.locations = locations
    gradient.startPoint = startPoint
    gradient.endPoint = endPoint
    gradient.zPosition = CGFloat(zPosition)
    layerAttachTo.addSublayer(gradient)
}



var qVController: QuestionViewController!

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var centralImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var bottomButton: UIButton!
    
    var gradient: CAGradientLayer!
    var currentSelectedAnswer: String!
    var currentRowIndex: Int = 0
    var congratStripOpenConstraint: NSLayoutConstraint!
    var congratStripCloseConstraint: NSLayoutConstraint!
    var answerStripOpenConstraint: NSLayoutConstraint!
    var answerStripCloseConstraint: NSLayoutConstraint!
    var phrases: [String] = [String]()
    var isBetweenQuestions: Bool = false
    var soundMute: Bool?
    
    //central views
    
    var images: [UIImage] = {
        let images: [UIImage] = [UIImage(named: "cars")!, UIImage(named: "findingnemo")!, UIImage(named: "duckstory")!, UIImage(named: "iceage")!, UIImage(named: "pinoccio")!, UIImage(named: "toystory")!, UIImage(named: "lionking")!]
        return images
    }()
    
    var scoreLabel: UILabel? = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    var spacingBetweenButtons: CGFloat = 8
    var spacingBetweenViews: CGFloat = 60
    var isViewTwoOpen: Bool = false
   
    
    /////////////////////////// VIEW /////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qVController = self
        ///dlya togo chtobi gradient menyal orientaciyu pri izmenenii raskladki
        NotificationCenter.default.addObserver(self, selector: #selector(QuestionViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        phrases = ["Yes!", "Exactly!", "Well Done!", "Okay!", "Fine!", "Right!", "True!"]
        ///nastroiki gradienta knopki NEXT, on statichniy
        ///uvilichivaem razmeri freima gradienta, cveta location add vse vnutri
        self.selfBackgroundGradientLayerSetup()
        theGameController.scoreLabel = self.scoreLabel
        theGameController.startGame()
        //central views
        isViewTwoOpen = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.gradientBackgroundColorAnimation()
        self.gradientBackgroundChangePositionAnimation()
    }
    
    ///dlya togo chtobi gradient menyal orientaciyu pri izmenenii raskladki
    func rotated() {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
            //print("landscape")
            ifOrientChanged()
        }
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
            //print("Portrait")
            ifOrientChanged()
        }
    }
    
    fileprivate func ifOrientChanged() {
        //gradient.frame = mainView.bounds
        gradientBackgroundColorAnimationStopAndStart()
    }
    
    
    ///////////////////////// PICKER VIEW DELEGATE//////////////// PICKER VIEW DELEGATE//////////////////
    
    
    
    // //////////////////////////////////////////// CUSTOM FUNCTIONS ///////////////////////////////////////
    
    func refreshCurrentFighterNameLabel(_ newLabelText: String) {
        //self.fighterNameLabel.text = newLabelText
    }
    
    
    func refreshCurrentFighterNameLabelWithAnimation(_ newLabelText: String, animationDirection: AnimationDirection) {
        
        //self.fighterNameLabel.text = newLabelText
        //cubeTransition(label: self.fighterNameLabel, text: newLabelText, direction: animationDirection)
    }
    
    ///// CUBE TRANSITION ANIMATION ////// ///// ///// /////
    
    enum AnimationDirection: Int {
        case positive = 1
        case negative = -1
    }
    
    // anim changing fighter title label with cube transition
    func cubeTransition(label: UILabel, text: String, direction: AnimationDirection) {
        
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.text = text
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = label.backgroundColor
        auxLabel.lineBreakMode = .byClipping
        
        let auxLabelOffset = CGFloat(direction.rawValue) *
            label.frame.size.height/2.0
        
        auxLabel.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: auxLabelOffset))
        
        label.superview!.addSubview(auxLabel)
        ///
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            auxLabel.transform = CGAffineTransform.identity
            label.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: -auxLabelOffset))
        }, completion: {_ in
            label.text = auxLabel.text
            label.transform = CGAffineTransform.identity
            auxLabel.removeFromSuperview()
        })
    }
    
    /////   /////   //////  /////// //////  ////
    
    func doSegueWithIdentifier(_ identif: String)
    {
        performSegue(withIdentifier: identif, sender: nil)
    }
    
    ///parametr lishniy         ///GRADIENT COLOR CHANGE IF WRONG
    func backGroundColorChangeAnimationOnAnswer(_ playerAnswerResult: String) {
        ///ne ispulzuetsya potomu chto dinamichniy zadniy background ne pozvolyaet eto, tak chto return
        ///eshe odin horoshiy variant pri oshibke, gradient menyaetsya na protivopolozhniy po simmetrii
        return  ///////////// Testing
        let anim = CABasicAnimation(keyPath: "colors")
        anim.toValue = [UIColor.blue.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor]
        anim.fromValue = [UIColor.red.cgColor, UIColor.red.cgColor, UIColor.red.cgColor]
        anim.duration = 1.5
        anim.repeatCount = 1
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        self.gradient.add(anim, forKey: nil)
        
        /// Predidushiy variant animacii pri oshibke v otvete. bckr s krasnogo na siniy
        
        /*let anim = CABasicAnimation(keyPath: "backgroundColor")
         
         switch playerAnswerResult {
         case "WRONG":
         anim.fromValue = UIColor.redColor().CGColor
         break
         default: break
         }
         anim.toValue = UIColor.blueColor().CGColor
         anim.duration = 1.5
         anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
         anim.repeatCount = 1
         self.gradientView.bacgroundcolor = blueColor()
         */
    }
    
    ///GRADIENT BACGR MIDDLE STRIP ANIM COLOR CHANGE   /// unused
    func gradientBackgroundColorAnimation() {
        
        let anim = CABasicAnimation(keyPath: "colors")
        ///1.
        anim.fromValue = [UIColor.blue.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        anim.toValue = [UIColor.blue.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor]
        
        //anim.fromValue = [UIColor.blueColor().CGColor, UIColor.redColor().CGColor, UIColor.blueColor().CGColor]
        //anim.toValue = [UIColor.redColor().CGColor, UIColor.blueColor().CGColor, UIColor.redColor().CGColor]
        
        anim.duration = 8
        anim.repeatCount = Float.infinity
        anim.autoreverses = true
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.gradient.add(anim, forKey: "asd")
    }
    
    func gradientBackgroundColorAnimationStopAndStart() {
        gradient.removeAnimation(forKey: "asd")
        //self.gradient.removeAllAnimations()
        gradientBackgroundColorAnimation()
    }
    
    func gradientBackgroundChangePositionAnimation() {
        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue = [0.0, 0.0, 0.25]
        anim.toValue = [0.75, 1.0, 1.0]
        anim.duration = 15
        //anim.autoreverses = true
        anim.repeatCount = Float.infinity
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.gradient.add(anim, forKey: nil)
    }
    
    
    ////// ANSWER BUTTON TITTLE SET ...
    
    func answerButtonSetState(_ state: String) {
        
        if theGameController.gameIsOver == true {
            return
        }
        switch state {
        case "OPEN":
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.7, options: [], animations: {
                if self.answerStripOpenConstraint.isActive == false {
                    self.answerStripOpenConstraint.isActive = true
                    self.answerStripCloseConstraint.isActive = false
                }
                self.view.layoutIfNeeded()          ///      ///       ///     ///
                // //////////////////////////////lllllllllllllllllllllllllllllll//
            }, completion: { _ in
            })
            
            break
        case "CLOSE":
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.7, options: [], animations: {
                if self.answerStripCloseConstraint.isActive == false {
                    self.answerStripCloseConstraint.isActive = true
                    self.answerStripOpenConstraint.isActive = false
                }
                self.view.layoutIfNeeded()
            }, completion: { _ in
            })
            break
        default:
            break
        }
        
    }
    
    func congratStripSetState(_ state: String) {
        if theGameController.gameIsOver == true {
            return
        }
        self.setRandomPhrase() /// SET RAAAANDOM PHRASEEEE
        switch state {
        case "OPEN":
            UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: UIViewAnimationOptions(), animations: {
                if self.congratStripCloseConstraint.isActive == true {
                    self.congratStripCloseConstraint.isActive = false
                    self.congratStripOpenConstraint.isActive = true
                }
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
            break
        case "CLOSE":
            UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: UIViewAnimationOptions(), animations: {
                if self.congratStripOpenConstraint.isActive == true {
                    self.congratStripOpenConstraint.isActive = false
                    self.congratStripCloseConstraint.isActive = true
                }
                self.view.layoutIfNeeded()
                
            }, completion: { _ in
                /// PICKER USER INTERACTION ENABLED
            })
            break
        default:
            break
        }
    }
    
    
    func changeFighterImageWithAnimation(_ toImage: UIImage) {
        /*
        if theGameController.gameIsOver == true {
            return
        }
        self.imageView.image = toImage
        imageView.image = toImage
        let pos = imageView.layer.position.y
        let anim = CASpringAnimation(keyPath: "position.y")
        anim.damping = 9.1
        anim.initialVelocity = 15.0
        anim.stiffness = 150.0
        anim.mass = 1.0
        anim.duration = anim.settlingDuration
        anim.fromValue = pos - 300
        anim.toValue = pos
        self.imageView.layer.add(anim, forKey: nil) */
    }
    
    
    func imageViewFlyDownAnimation() {
        /*
        if theGameController.gameIsOver == true {
            return
        }
        let pos = imageView.layer.position.y
        let animMove = CASpringAnimation(keyPath: "transform.scale")
        animMove.fromValue = 2.0
        animMove.toValue = 1.0
        animMove.duration = animMove.settlingDuration
        animMove.damping = 8.0
        self.fighterNameLabel.layer.add(animMove, forKey: nil)
         */
    }
    
    
    
    func setNewImage(_ imageName: String) {
        
    }
    
    
    func congratStripConstraintsSetToClose() {
        self.congratStripOpenConstraint.isActive = false
        self.congratStripCloseConstraint.isActive = true
    }
    
    func changeXtoDot() {
    }
    
    func answerButtonAnimationIfWrong() {
    }
    
    func answerButtonAnimationIfRight() {
        
    }
    
    func answerButtonAnimationOnPress() {
        return
        /*let anim = CASpringAnimation(keyPath: "transform.scale")
        anim.damping = 7.9
        anim.initialVelocity = 15.0
        //anim.stiffness = 100.0
        anim.mass = 1.0
        anim.duration = anim.settlingDuration
        anim.fromValue = 1.2
        anim.toValue = 1.0
        self.answerButton.layer.add(anim, forKey: nil)*/
    }
    
    
    ////////////////////////////// ANSWER BUTTON HANDLER /////////////////////// HANDLERS ////////////////

    
    @IBAction func returnToQuestionViewController(_ segue: UIStoryboardSegue) {
        
    }
    
    func selfBackgroundGradientLayerSetup() {
        gradient = CAGradientLayer()
        gradient.colors = [UIColor.blue.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.locations = [0.0, 0.0, 0.25]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.2)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.8)
        
        /// ( gradien uvilichivaem v shirinu dvoe i stavim po centru (x: - fra.siz.wi) )
        gradient.frame = CGRect(x: -self.view.frame.size.width / 3, y: 0.0, width: self.view.frame.size.width * 3, height: self.view.frame.size.height)
        gradient.zPosition = -10
        self.view.layer.addSublayer(gradient)
    }
    
   /* func congratuLationStripAndAnswerButtonsConstraintsInit() {
        congratStripOpenConstraint = NSLayoutConstraint(item: congratStrip, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 0.3, constant: 0.0) /// wtf 0.3 a ne 0.2
        
        congratStripCloseConstraint = NSLayoutConstraint(item: congratStrip, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 0.0, constant: 0.0)
        
        answerStripOpenConstraint = NSLayoutConstraint(item: answerButton, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 0.2, constant: 0.0)
        
        answerStripCloseConstraint = NSLayoutConstraint(item: answerButton, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 0.0, constant: 0.0)
        
        congratStripCloseConstraint.isActive = true
        answerStripOpenConstraint.isActive = true
    } */
    
    func setRandomPhrase() {
        let rand = Int(arc4random_uniform(UInt32(phrases.count)))
    }
    
    func createCentralViews() {
       
    }
    
    
   /* func setBlackButtonConstraints() {    knopka testovaya bila v samom nizy, kak next button
        let blackButtonVerticalConstraints = NSLayoutConstraint(item: self.blackButton, attribute: .height, relatedBy: .equal, toItem: self.mainView, attribute: .height, multiplier: 0.05, constant: 0.0)
        let blackButtonHorizontalConstraints = NSLayoutConstraint(item: self.blackButton, attribute: .width, relatedBy: .equal, toItem: self.mainView, attribute: .width, multiplier: 0.1, constant: 0.0)
        blackButtonVerticalConstraints.isActive = true
        blackButtonHorizontalConstraints.isActive = true
        self.blackButton.center = CGPoint(x: self.mainView.frame.width / 2, y: self.mainView.frame.height - self.mainView.frame.height * 0.1)
        self.blackButton.isUserInteractionEnabled = true
    } */
    @IBAction func bottomButtonPressed(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        isViewTwoOpen = !isViewTwoOpen
        let imageIndex = arc4random_uniform(UInt32(self.images.count))
        let image = images[Int(imageIndex)]
        self.secondImageView?.image = image
        MPFoldTransition.transition(from: self.centralImageView, to: self.secondImageView, duration: 1, style: UInt(MPFoldStyleCubic), transitionAction: MPTransitionActionNone, completion: {_ in
            self.centralImageView?.image = image
            sender.isUserInteractionEnabled = true
        })

    }
}


extension QuestionViewController {
    
}
