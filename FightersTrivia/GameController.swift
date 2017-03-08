//
//  GameController.swift
//  Guess the Fighter, Угадай Бойца
//
//  Created by Artem on 11/14/16.
//  Copyright © 2016 piqapp. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AudioToolbox

//var highScore: Int!

var theGameController: GameController!

class GameController {
    
    var currentQuestion: TheQuestion!
    var score: Int = 0
    var highscore: Int
    var scoreLabel: UILabel?
    var soundMute: Bool?
    var gameIsOver: Bool = false
    
    var questionsInLevel: Int  = 5
    var isItFirstQuestion: Bool = true
    var currentQuestionIndex: Int = 0
    var currentLevelIndex: Int = 1

    init() {
        //highscore
        if let hs = UserDefaults.standard.value(forKey: "highscore") as? Int {
            self.highscore = hs
        } else {
            self.highscore = 0
        }
    }
   
    func startGame() {
        ///zapustit igru
        self.initGame()
        
    }
    
    func restartGame() {
        self.initGame()
    }
    
    func initCurrentQuestion() {
       
    }
    
    func initGame() {
        self.score = 0
        self.gameIsOver = false
        self.isItFirstQuestion = true
        self.scoreLabel!.text = score.description
        
    }
    
    func initStartUpGameValues() {
        self.score = 0
        self.gameIsOver = false
        self.isItFirstQuestion = true
        self.scoreLabel!.text = score.description
        self.highscore = UserDefaults.standard.value(forKey: "highscore") as! Int
    }
    
    // MARK: - player was wrong
    func playerWasWrongSkipThisQuestion() {
        
    }
    // MARK: - player was right
    func playerWasRightGoToTheNextQuestion() {
        
    }
    // MARK: - check right or wrong
    func checkRightOrWrong() {
    }
    
    // MARK: - right answer
    func playerDidRightAnswer() {
        playSound("RIGHT")
    }
    
    // MARK: - wrong answer
    func playerDidMistake() {
    }
    
    // MARK: - to the next question
    func goToTheNextQuestion() {
    }
    
    
    
    ///     GAME DONE
    func wholeGameIsPathedBy() {
        self.gameIsOver = true
        playSound("GAMEDONE")
        qVController.doSegueWithIdentifier("showGameDone")
    }
    
    func playSound(_ soundName: String) {
        if self.soundMute == true {
            return
        }
        switch soundName {
        case "RIGHT":
            AudioServicesPlaySystemSound(1440)//1394)
            break
        case "WRONG":
            AudioServicesPlaySystemSound(1053)
            break
        case "GAMEOVER":
            AudioServicesPlaySystemSound(1006)
            break
        case "ACHIEVMENT":
            AudioServicesPlaySystemSound(1383)
            break
        case "SCROLL":
            AudioServicesPlaySystemSound(1121) //1222
            break
        case "GAMEDONE":
            AudioServicesPlaySystemSound(1332)
            break
        case "CHANGEIMAGE":
            AudioServicesPlaySystemSound(1129)
            break
        case "CLICK":
            AudioServicesPlaySystemSound(1130)
        default:
            break
        }
    }
    
    func checkIfHighScore(_ yourScore: Int) -> Bool {
        var r: Bool = false
        if yourScore > self.highscore {
            print("NEW HIGHSCORE")
            self.highscore = yourScore
            UserDefaults.standard.set(self.highscore, forKey: "highscore")
            r = true
        }
        if yourScore == self.highscore {
            /// Uteshit igroka potomu chto emu ne hvatilo vsego 1 ochka do highscore :)
        }
        return r
    }
}


/*self.betweenQuestionView = UIView(frame: qVController.picker.frame)
 betweenQuestionView.backgroundColor = UIColor.green
 betweenQuestionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 betweenQuestionView.tag = 1 // the tag to remove
 betweenQuestionView.isHidden = true
 qVController.view.addSubview(betweenQuestionView) */


// do novogo goda ne, eto mesyac, kakraz dazvno uzhe nuzhna pauza, pod mastyu uzhe podplavilo prilozhuhu delat a delat nado
// pri etom pomnyu kak eto bilo produktivno na chistuyu, film odin doma, ng s pacanami i pervogo chisla raskur, za mesyac podgotovit k apstoru, treshi, relief na kreshenie, zamenim eto skakalochkoi

//NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(seconds), target: self, selector: selector, userInfo: nil, repeats: false)



/// RIGHT 1394 (1407) 1430 1473 1440       WRONG 1053 1006

/// click 1057    1103    1130

/// 1128        1129 trnasition from to sound 1109 1018 1303

/// 1429 picker scroll

/// 1335 1368 1383 achiev 1034 1035

/// game done 1332
// 1052 1431 1433 right





