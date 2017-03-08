//
//  FoldTestViewController.swift
//  KefirFoldTransition
//
//  Created by Artem on 3/1/17.
//  Copyright © 2017 ApiqA. All rights reserved.
//

import UIKit

class FoldTestViewController: UIViewController {        // ETO PRIGODILOS KOGDA FOLD TRANSITION VSTAVLYALI
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    
    var viewOne: UIView? = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.magenta
        return view
    }()
    var centralView: UIView? = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        return view
    }()
    var imageViewOne: UIImageView? = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = UIColor.black
        return imageView
    }()
    var centralImageView: UIImageView? = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = UIColor.darkGray
        return imageView
    }()
    var blackButton: UIButton? = {
        let button = UIButton()
        button.addTarget(self, action: #selector(blackButtonHandler), for: .touchUpInside)
        button.setTitle("BITCH", for: .normal)
        button.backgroundColor = UIColor.black
        button.titleLabel!.font = UIFont.systemFont(ofSize: 21, weight: UIFontWeightThin)
        return button
    }()
    var redButton: UIButton? = {
        let button = UIButton()
        button.addTarget(self, action: #selector(redButtonHandler), for: .touchUpInside)
        button.setTitle("DICH", for: .normal)
        button.backgroundColor = UIColor.red
        button.titleLabel!.font = UIFont.systemFont(ofSize: 21, weight: UIFontWeightThin)
        return button
    }()
    var colors: [UIColor] = {
        let colors = [UIColor.red, UIColor.gray, UIColor.green, UIColor.blue, UIColor.black, UIColor.magenta, UIColor.cyan, UIColor.orange, UIColor.purple]
        return colors
    }()
    
    var spacingBetweenButtons: CGFloat = 8
    var spacingBetweenViews: CGFloat = 60
    var isViewTwoOpen: Bool = false
    
    // MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        isViewTwoOpen = false
        addSubViews([viewOne, centralView, redButton, blackButton])
        self.centralView?.addSubview(self.centralImageView!)
    }
    // MARK: - view will appear
    override func viewWillAppear(_ animated: Bool) {
        layoutSubviews()
    }
    
    
    
    // MARK: - actions
    func blackButtonHandler(_ sender: UIButton!) {  //works with three views, swap between 2 views
        sender.isUserInteractionEnabled = false
        isViewTwoOpen = !isViewTwoOpen
        let toView = isViewTwoOpen ? self.labelTwo : self.labelOne
        MPFoldTransition.transition(from: self.labelThree, to: toView, duration: 1, style: UInt(MPFoldStyleCubic), transitionAction: MPTransitionActionNone, completion: {_ in
            self.labelThree.backgroundColor = toView?.backgroundColor
            self.labelThree.text = toView?.text
            sender.isUserInteractionEnabled = true
        })
        
        MPFoldTransition.transition(from: self.redButton, to: self.blackButton, duration: 1, style: UInt(MPFoldStyleHorizontal), transitionAction: MPTransitionActionNone, completion: {_ in
            sender.isUserInteractionEnabled = true
            self.blackButton?.backgroundColor = UIColor.black
            self.blackButton?.setTitle("BITCH", for: .normal)
        })
    }
    
    func redButtonHandler(_ sender: UIButton!) {    //works with two views, one view change backg color
        sender.isUserInteractionEnabled = false
        isViewTwoOpen = !isViewTwoOpen
        //let toView = isViewTwoOpen ? self.viewTwo : self.viewOne
        let colorIndex = arc4random_uniform(UInt32(self.colors.count))
        let color = colors[Int(colorIndex)]
        self.viewOne?.backgroundColor = color
        MPFoldTransition.transition(from: self.centralView, to: viewOne, duration: 1, style: UInt(MPFoldStyleCubic), transitionAction: MPTransitionActionNone, completion: {_ in
            self.centralView?.backgroundColor = color
            sender.isUserInteractionEnabled = true
        })
        
        MPFoldTransition.transition(from: self.blackButton, to: self.redButton, duration: 1, style: UInt(MPFoldStyleHorizontal), transitionAction: MPTransitionActionNone, completion: {_ in
            sender.isUserInteractionEnabled = true
            self.redButton?.backgroundColor = UIColor.red
            self.redButton?.setTitle("DICH", for: .normal)
        })
    }
}

//************* CUSTOM METHODS **************//
extension FoldTestViewController {
    func addSubViews(_ views: [UIView?]) {
        for view in views {
            if let view_ = view {
                self.view.addSubview(view_)
            }
        }
    }
    func layoutSubviews() {
        // fold label on top
        let labelFrame = CGRect(x: 0, y: 0, width: view.frame.width * 0.4, height: view.frame.height * 0.1)
        self.labelThree.frame = labelFrame
        self.labelThree.center = CGPoint(x: view.frame.width/2, y: view.frame.height * 0.1)
        // view one view two
        let centralViewsFrame = CGRect(x: 0, y: 0, width: view.frame.width * 0.8, height: self.view.frame.height * 0.4)
        viewOne?.frame = centralViewsFrame
        viewOne?.center = CGPoint(x: self.view.frame.width/2, y: -centralViewsFrame.height/2) // za predelami ekrana
        
        // poziciya central view na 'spacing' nizhe labelThree
        centralView?.frame = CGRect(x: view.frame.width/2 - centralViewsFrame.width/2, y: self.labelThree.center.y + self.labelThree.frame.height/2 + self.spacingBetweenViews, width: view.frame.width * 0.8, height: self.view.frame.height * 0.4)
        
        let buttonFrame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.2, height: self.view.frame.height * 0.05)
        self.blackButton?.frame = buttonFrame
        self.blackButton?.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - self.view.frame.height * 0.1)
        self.redButton?.frame = buttonFrame
        self.redButton?.center = CGPoint(x: self.blackButton!.center.x, y: self.blackButton!.center.y - self.spacingBetweenButtons - self.redButton!.frame.height)
        
    }
}

