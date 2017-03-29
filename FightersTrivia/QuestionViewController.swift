//
//  QuestionViewController.swift
//  Guess the Fighter, Угадай Бойца
//
//  Created by Artem on 11/14/16.
//  Copyright © 2016 piqapp. All rights reserved.

///FONTS///

// Avenir-LightOblique  AvenirNext-UltraLight Didot-Bold HelveticaNeue-UltraLight PingFangHK-Ultralight PingFangTC-Thin


import UIKit
import BetterSegmentedControl

// IMPORTANT FOR CONSTRAINTS
extension NSLayoutConstraint {
    
    public class func useAndActivateConstraints(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            if let view = constraint.firstItem as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        activate(constraints)
    }
}

var qVController: QuestionViewController!

class QuestionViewController: UIViewController {
    
    var currentQuestion: TheQuestion!
    
    @IBOutlet weak var centralImageView: UIImageView!
    @IBOutlet weak var congratStripView: UIView!
    @IBOutlet weak var congratStripLabel: UILabel!
    @IBOutlet weak var congratStripNumber: UILabel!
    
    @IBOutlet weak var secondImageView: UIImageView!
    
    var betterSegmentedControlCurrentTitlesFirst = [String]()
    var betterSegmentedControlCurrentTitlesSecond = [String]()
    
    var betterSegmentedControlFirst: BetterSegmentedControl = {
        let betterSegmentedControl = BetterSegmentedControl(
            frame: CGRect.zero,
            titles: ["Default", "Default"],
            index: 5,
            backgroundColor: .clear,
            titleColor: .white,
            indicatorViewBackgroundColor: .black,
            selectedTitleColor: .white)
        betterSegmentedControl.titleFont = UIFont.systemFont(ofSize: 21, weight: UIFontWeightThin)
        betterSegmentedControl.selectedTitleFont = UIFont.systemFont(ofSize: 21, weight: UIFontWeightLight)
        betterSegmentedControl.cornerRadius = 20.0
        return betterSegmentedControl
    }()
    
    var betterSegmentedControlSecond: BetterSegmentedControl = {
        let betterSegmentedControl = BetterSegmentedControl(
            frame: CGRect.zero,
            titles: ["Default", "Default"],
            index: 5,
            backgroundColor: .clear,
            titleColor: .white,
            indicatorViewBackgroundColor: .black,
            selectedTitleColor: .white)
        betterSegmentedControl.titleFont = UIFont.systemFont(ofSize: 21, weight: UIFontWeightThin)
        betterSegmentedControl.selectedTitleFont = UIFont.systemFont(ofSize: 21, weight: UIFontWeightLight)
        betterSegmentedControl.cornerRadius = 20.0
        return betterSegmentedControl
    }()
    
    var gradient: CAGradientLayer!
    var segmentedControlFirstGradient: CAGradientLayer!
    var segmentedControlSecondGradient: CAGradientLayer!
    
    
    var currentSelectedAnswer: String!
    var currentRowIndex: Int = 0
    var congratStripConstraintHorizontalFirstState: NSLayoutConstraint!
    var congratStripConstraintHorizontalMiddleState: NSLayoutConstraint!
    var congratStripConstraintHorizontalThirdState: NSLayoutConstraint!

    
    var phrases: [String] = [String]()
    var isBetweenQuestions: Bool = false
    var soundMute: Bool?
    
    var spacingBetweenButtons: CGFloat = 8
    var spacingBetweenViews: CGFloat = 60
    var isViewTwoOpen: Bool = false
   
    
    // MARK - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        qVController = self
        ///dlya togo chtobi gradient menyal orientaciyu pri izmenenii raskladki
        NotificationCenter.default.addObserver(self, selector: #selector(QuestionViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        phrases = ["Yes!", "Exactly!", "Well Done!", "Okay!", "Fine!", "Right!", "True!"]
        ///uvilichivaem razmeri freima gradienta, cveta location add vse vnutri
        self.selfBackgroundGradientLayerSetup()
        theGameController.scoreLabel = congratStripNumber
        theGameController.startGame()
        isViewTwoOpen = false
        // initial image
        self.centralImageView.image = theGameController.dataSource.questions[0].image
        centralImageView.isUserInteractionEnabled = true
        
        currentQuestion = theGameController.questions?[0]
        
        initSegmentedControl()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setBetterSegmentedControlFirstConstraints()
        self.setBetterSegmentedControlSecondConstraints()
        self.congratStripLabelConstraints()
        self.congratStripNumberConstraints()
        self.congratStripInitialConstraints()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.gradientBackgroundColorAnimation()
        self.gradientBackgroundChangePositionAnimation()
        self.segmentedControlFirstGradientSetup()
        self.segmentedControlSecondGradientSetup()
    }
    func refreshCurrentFighterNameLabelWithAnimation(_ newLabelText: String, animationDirection: AnimationDirection) {
        //self.fighterNameLabel.text = newLabelText
        //cubeTransition(label: self.fighterNameLabel, text: newLabelText, direction: animationDirection)
    }
    func doSegueWithIdentifier(_ identif: String)
    {
        performSegue(withIdentifier: identif, sender: nil)
    }
    
    func congratStripSetState(_ state: String) {
        if theGameController.gameIsOver == true {
            return
        }
        self.setRandomPhrase() /// SET RAAAANDOM PHRASEEEE
        switch state {
        case "FIRST":
            if self.congratStripConstraintHorizontalThirdState != nil {
                if self.congratStripConstraintHorizontalThirdState.isActive == true {
                    self.congratStripConstraintHorizontalThirdState.isActive = false
                }
            }
            if self.congratStripConstraintHorizontalMiddleState != nil {
                if self.congratStripConstraintHorizontalMiddleState.isActive == true {
                    self.congratStripConstraintHorizontalMiddleState.isActive = false
                }
            }
            if self.congratStripConstraintHorizontalFirstState != nil {
                self.congratStripConstraintHorizontalFirstState.isActive = true
            } else {
                self.congratStripViewFirstStateConstraints()
            }
            break
        case "MIDDLE":
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: UIViewAnimationOptions(), animations: {
                if self.congratStripConstraintHorizontalFirstState != nil {
                    if self.congratStripConstraintHorizontalFirstState.isActive == true {
                        self.congratStripConstraintHorizontalFirstState.isActive = false
                    }
                }
                if self.congratStripConstraintHorizontalThirdState != nil {
                    if self.congratStripConstraintHorizontalThirdState.isActive == true {
                        self.congratStripConstraintHorizontalThirdState.isActive = false
                    }
                }
                if self.congratStripConstraintHorizontalMiddleState != nil {
                    self.congratStripConstraintHorizontalMiddleState.isActive = true
                } else {
                    self.congratStripViewMiddleStateConstraints()
                }
                self.view.layoutIfNeeded()
            }, completion: { _ in
                /// PICKER USER INTERACTION ENABLED
            })
            break
        case "THIRD":
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: UIViewAnimationOptions(), animations: {
                if self.congratStripConstraintHorizontalMiddleState != nil {
                    if self.congratStripConstraintHorizontalMiddleState.isActive == true {
                        self.congratStripConstraintHorizontalMiddleState.isActive = false
                    }
                }
                if self.congratStripConstraintHorizontalFirstState != nil {
                    if self.congratStripConstraintHorizontalFirstState.isActive == true {
                        self.congratStripConstraintHorizontalFirstState.isActive = false
                    }
                }
                if self.congratStripConstraintHorizontalThirdState != nil {
                    self.congratStripConstraintHorizontalThirdState.isActive = true
                } else {
                    self.congratStripViewThirdStateConstraints()
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
    func setNewImage(_ imageName: String) {
    }
    func changeXtoDot() {
    }
    func answerButtonAnimationIfWrong() {
    }
    func answerButtonAnimationIfRight() {
    }
    @IBAction func returnToQuestionViewController(_ segue: UIStoryboardSegue) {
    }
    func setRandomPhrase() {
        //let rand = Int(arc4random_uniform(UInt32(phrases.count)))
    }

    func setBetterSegmentedControlFirstConstraints() {
         ///translatesAutoresizingMaskIntoConstraints - in extension for NSLayourConstraints
         //knopka testovaya bila v samom nizy, kak next button
         let height = NSLayoutConstraint(item: betterSegmentedControlFirst, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.1, constant: 0.0)
         let width = NSLayoutConstraint(item: betterSegmentedControlFirst, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0)
        let vertical = NSLayoutConstraint(item: betterSegmentedControlFirst, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.8, constant: 0.0)
        let horizontal = NSLayoutConstraint(item: betterSegmentedControlFirst, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        var constraints = [NSLayoutConstraint]()
        constraints.append(height)
        constraints.append(width)
        constraints.append(vertical)
        constraints.append(horizontal)
        NSLayoutConstraint.useAndActivateConstraints(constraints: constraints)
    }
    
    func setBetterSegmentedControlSecondConstraints() {
        ///translatesAutoresizingMaskIntoConstraints - in extension for NSLayourConstraints
        //knopka testovaya bila v samom nizy, kak next button
        let height = NSLayoutConstraint(item: betterSegmentedControlSecond, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.1, constant: 0.0)
        let width = NSLayoutConstraint(item: betterSegmentedControlSecond, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0)
        let vertical = NSLayoutConstraint(item: betterSegmentedControlSecond, attribute: .bottom, relatedBy: .equal, toItem: betterSegmentedControlFirst, attribute: .top, multiplier: 0.99, constant: 0.0)
        let horizontal = NSLayoutConstraint(item: betterSegmentedControlSecond, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        var constraints = [NSLayoutConstraint]()
        constraints.append(height)
        constraints.append(width)
        constraints.append(vertical)
        constraints.append(horizontal)
        NSLayoutConstraint.useAndActivateConstraints(constraints: constraints)
    }
    
    
    func congratStripInitialConstraints() {
        let height = NSLayoutConstraint(item: congratStripView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.1, constant: 0.0)
        let width = NSLayoutConstraint(item: congratStripView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0.0)
        let vertical = NSLayoutConstraint(item: congratStripView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.1, constant: 0.0)
        congratStripConstraintHorizontalFirstState = NSLayoutConstraint(item: congratStripView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: -1.0, constant: 0.0)
        var constraints = [NSLayoutConstraint]()
        constraints.append(height)
        constraints.append(width)
        constraints.append(vertical)
        constraints.append(congratStripConstraintHorizontalFirstState)
        NSLayoutConstraint.useAndActivateConstraints(constraints: constraints)
    }
    
    func congratStripViewFirstStateConstraints() {
        congratStripConstraintHorizontalFirstState = NSLayoutConstraint(item: congratStripView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: -1.0, constant: 0.0)
        var constraints = [NSLayoutConstraint]()
        constraints.append(congratStripConstraintHorizontalFirstState)
        NSLayoutConstraint.useAndActivateConstraints(constraints: constraints)
    }
    
    func congratStripViewMiddleStateConstraints() {
        congratStripConstraintHorizontalMiddleState = NSLayoutConstraint(item: congratStripView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        var constraints = [NSLayoutConstraint]()
        constraints.append(congratStripConstraintHorizontalMiddleState)
        NSLayoutConstraint.useAndActivateConstraints(constraints: constraints)
    }
    
    func congratStripViewThirdStateConstraints() {
        congratStripConstraintHorizontalThirdState = NSLayoutConstraint(item: congratStripView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 3.0, constant: 0.0)
        var constraints = [NSLayoutConstraint]()
        constraints.append(congratStripConstraintHorizontalThirdState)
        NSLayoutConstraint.useAndActivateConstraints(constraints: constraints)
    }
    
    func congratStripLabelConstraints() {
        let height = NSLayoutConstraint(item: congratStripLabel, attribute: .height, relatedBy: .equal, toItem: congratStripView, attribute: .height, multiplier: 1.0, constant: 0.0)
        let width = NSLayoutConstraint(item: congratStripLabel, attribute: .width, relatedBy: .equal, toItem: congratStripView, attribute: .width, multiplier: 0.8, constant: 0.0)
        let vertical = NSLayoutConstraint(item: congratStripLabel, attribute: .centerY, relatedBy: .equal, toItem: congratStripView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let horizontal = NSLayoutConstraint(item: congratStripLabel, attribute: .centerX, relatedBy: .equal, toItem: congratStripView, attribute: .centerX, multiplier: 0.8, constant: 0.0)
        var constraints = [NSLayoutConstraint]()
        constraints.append(height)
        constraints.append(width)
        constraints.append(vertical)
        constraints.append(horizontal)
        NSLayoutConstraint.useAndActivateConstraints(constraints: constraints)
    }
    
    func congratStripNumberConstraints() {
        let height = NSLayoutConstraint(item: congratStripNumber, attribute: .height, relatedBy: .equal, toItem: congratStripView, attribute: .height, multiplier: 1.0, constant: 0.0)
        let width = NSLayoutConstraint(item: congratStripNumber, attribute: .width, relatedBy: .equal, toItem: congratStripView, attribute: .width, multiplier: 0.2, constant: 0.0)
        let vertical = NSLayoutConstraint(item: congratStripNumber, attribute: .centerY, relatedBy: .equal, toItem: congratStripView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let horizontal = NSLayoutConstraint(item: congratStripNumber, attribute: .centerX, relatedBy: .equal, toItem: congratStripView, attribute: .centerX, multiplier: 1.8, constant: 0.0)
        var constraints = [NSLayoutConstraint]()
        constraints.append(height)
        constraints.append(width)
        constraints.append(vertical)
        constraints.append(horizontal)
        NSLayoutConstraint.useAndActivateConstraints(constraints: constraints)
    }
    
    func switchImage() {
        let image = theGameController.currentQuestion.image
        self.secondImageView?.image = image
        MPFoldTransition.transition(from: self.centralImageView, to: self.secondImageView, duration: 0.5, style: UInt(MPFoldStyleCubic), transitionAction: MPTransitionActionNone, completion: {_ in
            self.centralImageView?.image = theGameController.currentQuestion.image
            self.setBetterSegmentedControlFirstConstraints()
            self.setBetterSegmentedControlSecondConstraints()
        })
    }
    
    func segmentedControlFirstValueChanged(_ sender: BetterSegmentedControl) {
        self.segmentedControlAnimationOnPress()
        var selectedAnswer: String!
        let index: Int = Int(self.betterSegmentedControlFirst.index)
        selectedAnswer = betterSegmentedControlCurrentTitlesFirst[index]
        theGameController.checkRightOrWrong(selectedAnswer)
    }
    
    func segmentedControlSecondValueChanged(_ sender: BetterSegmentedControl) {
        self.segmentedControlAnimationOnPress()
        var selectedAnswer: String!
        let index: Int = Int(self.betterSegmentedControlSecond.index)
        selectedAnswer = betterSegmentedControlCurrentTitlesSecond[index]
        theGameController.checkRightOrWrong(selectedAnswer)
    }
    
    /**************************SEGMENTED*********************/
    func initSegmentedControl() {
        let betterSegmentedControlFirst = BetterSegmentedControl(
            frame: CGRect.zero,
            titles: ["Default", "Default"],
            index: 5,
            backgroundColor: .clear,
            titleColor: .white,
            indicatorViewBackgroundColor: .black,
            selectedTitleColor: .white)
        betterSegmentedControlFirst.titleFont = UIFont.systemFont(ofSize: 21, weight: UIFontWeightThin)
        betterSegmentedControlFirst.selectedTitleFont = UIFont.systemFont(ofSize: 21, weight: UIFontWeightLight)
        betterSegmentedControlFirst.cornerRadius = 20.0
        self.betterSegmentedControlFirst = betterSegmentedControlFirst
        
        let betterSegmentedControlSecond = BetterSegmentedControl(
            frame: CGRect.zero,
            titles: ["Default", "Default"],
            index: 5,
            backgroundColor: .clear,
            titleColor: .white,
            indicatorViewBackgroundColor: .red,
            selectedTitleColor: .white)
        betterSegmentedControlSecond.titleFont = UIFont.systemFont(ofSize: 21, weight: UIFontWeightThin)
        betterSegmentedControlSecond.selectedTitleFont = UIFont.systemFont(ofSize: 21, weight: UIFontWeightLight)
        betterSegmentedControlSecond.cornerRadius = 20.0
        self.betterSegmentedControlSecond = betterSegmentedControlSecond
        
        betterSegmentedControlFirst.addTarget(self, action: #selector(self.segmentedControlFirstValueChanged(_:)), for: .valueChanged)
        betterSegmentedControlSecond.addTarget(self, action: #selector(self.segmentedControlSecondValueChanged(_:)), for: .valueChanged)
        
        view.addSubview(betterSegmentedControlFirst)
        view.addSubview(betterSegmentedControlSecond)
        
        getAnswersForSegmentedControls()
    }
    
    func removeSegmentedControls() {
        betterSegmentedControlFirst.removeFromSuperview()
        betterSegmentedControlSecond.removeFromSuperview()
    }
    
    func getAnswersForSegmentedControls() {
        betterSegmentedControlCurrentTitlesFirst = Array(theGameController.currentQuestionAnswerList[3..<6])
        betterSegmentedControlFirst.titles = betterSegmentedControlCurrentTitlesFirst
        betterSegmentedControlCurrentTitlesSecond = Array(theGameController.currentQuestionAnswerList[0..<3])
        betterSegmentedControlSecond.titles = betterSegmentedControlCurrentTitlesSecond
    }

    func indicatorViewBackChange(_ toColor: UIColor,_ segmented: BetterSegmentedControl) {
        
    }
    
    func segmentedGradientBackChange(_ result: String) {
        let anim = CABasicAnimation(keyPath: "colors")
        switch result {
            case "RIGHT":
                anim.fromValue = [UIColor.green.cgColor, UIColor.green.cgColor, UIColor.green.cgColor]
            break
            case "WRONG":
                anim.fromValue = [UIColor.red.cgColor, UIColor.red.cgColor, UIColor.red.cgColor]
            break
        default:
            break
        }
        anim.toValue = [UIColor.green.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor]
        anim.duration = 1.5
        anim.repeatCount = 1
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        self.segmentedControlFirstGradient.add(anim, forKey: nil)
        self.segmentedControlSecondGradient.add(anim, forKey: nil)
    }
    
    func controlsInteractionEnabled(_ bool: Bool) {
        betterSegmentedControlFirst.isUserInteractionEnabled = bool
        betterSegmentedControlSecond.isUserInteractionEnabled = bool
    }
    
    func mainGradientBackChange(_ result: String) {
        let anim = CABasicAnimation(keyPath: "colors")
        switch result {
        case "RIGHT":
            anim.fromValue = [UIColor.green.cgColor, UIColor.red.cgColor, UIColor.green.cgColor]
            break
        case "WRONG":
            anim.fromValue = [UIColor.red.cgColor, UIColor.red.cgColor, UIColor.red.cgColor]
            break
        default:
            break
        }
        anim.toValue = [UIColor.blue.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor]
        anim.duration = 1.5
        anim.repeatCount = 1
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        self.gradient.add(anim, forKey: nil)
        self.gradient.add(anim, forKey: nil)
    }
}

                            // GRADIENT
                        // GRADIENT
                    // GRADIENT
// MARK: - GRADIENT
extension QuestionViewController {
    func rotated() {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
            ifOrientChanged()
        } else if (UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
            ifOrientChanged()
        }
    }
    func ifOrientChanged() {
        gradientBackgroundColorAnimationStopAndStart()
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
    
    func segmentedControlFirstGradientSetup() {
        segmentedControlFirstGradient = CAGradientLayer()
        segmentedControlFirstGradient.colors = [UIColor.green.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor]
        segmentedControlFirstGradient.locations = [0.0, 0.0, 1.0]
        segmentedControlFirstGradient.startPoint = CGPoint(x: 0.0, y: 1.2)
        segmentedControlFirstGradient.endPoint = CGPoint(x: 1.0, y: 0.8)
        segmentedControlFirstGradient.frame = betterSegmentedControlFirst.frame
        segmentedControlFirstGradient.zPosition = -1
        segmentedControlFirstGradient.cornerRadius = 20.0
        self.view.layer.addSublayer(segmentedControlFirstGradient)
    }
    
    func segmentedControlSecondGradientSetup() {
        segmentedControlSecondGradient = CAGradientLayer()
        segmentedControlSecondGradient.colors = [UIColor.green.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor]
        segmentedControlSecondGradient.locations = [0.0, 0.0, 1.0]
        segmentedControlSecondGradient.startPoint = CGPoint(x: 0.0, y: 1.2)
        segmentedControlSecondGradient.endPoint = CGPoint(x: 1.0, y: 0.8)
        segmentedControlSecondGradient.frame = betterSegmentedControlSecond.frame
        segmentedControlSecondGradient.zPosition = -1
        segmentedControlSecondGradient.cornerRadius = 20.0
        self.view.layer.addSublayer(segmentedControlSecondGradient)
    }
    
    ///unused
    func gradientBackgroundColorAnimation() {
        let anim = CABasicAnimation(keyPath: "colors")
        anim.fromValue = [UIColor.white.cgColor, UIColor.green.cgColor, UIColor.white.cgColor]
        anim.toValue = [UIColor.green.cgColor, UIColor.red.cgColor, UIColor.blue.cgColor]
        //anim.fromValue = [UIColor.blueColor().CGColor, UIColor.redColor().CGColor, UIColor.blueColor().CGColor]
        //anim.toValue = [UIColor.redColor().CGColor, UIColor.blueColor().CGColor, UIColor.redColor().CGColor]
        anim.duration = 30
        anim.repeatCount = Float.infinity
        anim.autoreverses = true
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //self.gradient.add(anim, forKey: "asd")
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
        anim.duration = 60
        anim.autoreverses = true
        anim.repeatCount = Float.infinity
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.gradient.add(anim, forKey: nil)
    }
}

                            // OTHER ANIMATION
                        // OTHER ANIMATION
                    // OTHER ANIMATION
// MARK: - OTHER ANIMATION
extension QuestionViewController {
// label text change cube transition animation
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
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            auxLabel.transform = CGAffineTransform.identity
            label.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(CGAffineTransform(translationX: 0.0, y: -auxLabelOffset))
        }, completion: {_ in
            label.text = auxLabel.text
            label.transform = CGAffineTransform.identity
            auxLabel.removeFromSuperview()
        })
    }
    
    func segmentedControlAnimationOnPress(gradientOnly: Bool = false) {
        let anim = CASpringAnimation(keyPath: "transform.scale")
        anim.damping = 7.9
        anim.initialVelocity = 15.0
        //anim.stiffness = 100.0
        anim.mass = 1.0
        anim.duration = anim.settlingDuration
        anim.fromValue = 1.2
        anim.toValue = 1.0
        
        self.segmentedControlFirstGradient.add(anim, forKey: nil)
        self.segmentedControlSecondGradient.add(anim, forKey: nil)
        if gradientOnly {return}
        self.betterSegmentedControlFirst.layer.add(anim, forKey: nil)
        self.betterSegmentedControlSecond.layer.add(anim, forKey: nil)
    }
    
}

                            // UNUSED
                        // UNUSED
                    // UNUSED
// MARK: - UNUSED
extension QuestionViewController {
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
    func congratuLationStripAndAnswerButtonsConstraintsInit() { /*
     congratStripOpenConstraint = NSLayoutConstraint(item: congratStrip, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 0.3, constant: 0.0) /// wtf 0.3 a ne 0.2
     
     congratStripCloseConstraint = NSLayoutConstraint(item: congratStrip, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 0.0, constant: 0.0)
     
     answerStripOpenConstraint = NSLayoutConstraint(item: answerButton, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 0.2, constant: 0.0)
     
     answerStripCloseConstraint = NSLayoutConstraint(item: answerButton, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 0.0, constant: 0.0)
     
     congratStripCloseConstraint.isActive = true
     answerStripOpenConstraint.isActive = true */
     }
    func changeFighterImageWithAnimation(_ toImage: UIImage) { /*
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
    func backGroundColorChangeAnimationOnAnswer(_ playerAnswerResult: String) { /*
        // esli otvetil nepravilno
        //ne ispulzuetsya potomu chto dinamichniy zadniy background ne pozvolyaet eto, tak chto return
        //eshe odin horoshiy variant pri oshibke, gradient menyaetsya na protivopolozhniy po simmetrii
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
         */ */
    }
}
