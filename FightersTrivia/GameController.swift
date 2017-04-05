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
    
    var questions: [TheQuestion]? = {
        var questions = [TheQuestion]()
        return questions
    }()
    
    var currentQuestion: TheQuestion!
    var currentQuestionIndex: Int = 0
    var currentQuestionAnswerList = [String]()
    var answerListCount: Int = 6
    var currentQuestionRightIndex: Int!
    
    var isItFirstQuestion: Bool = true
    var score: Int = 0
    var highscore: Int
    var scoreLabel: UILabel?
    var soundMute: Bool?
    var gameIsOver: Bool = false
    var dataSource: DataSource!
    
    init() {
        //highscore check, first launch check
        if let hs = UserDefaults.standard.value(forKey: "highscore") as? Int {
            self.highscore = hs
        } else {
            self.highscore = 0
            UserDefaults.standard.set(self.highscore, forKey: "highscore")
        }
        self.dataSource = DataSource()
        questions = dataSource.questions
    }
   
    func startGame() {
        self.initGame()
    }
    
    func restartGame() {
        self.initGame()
    }
    
    func initCurrentQuestion() {
        if (questions?.count)! <= currentQuestionIndex {
            print("NO QUESTIONS")
            wholeGameIsPathedBy()
            return
        }
        currentQuestion = questions?[currentQuestionIndex]
        currentQuestionAnswerList = getRandomAnswers(howmany: answerListCount)
        currentQuestionRightIndex = generateRightAnswer()
        qVController.switchImage()
        qVController.initSegmentedControl()
        qVController.getAnswersForSegmentedControls()
        qVController.controlsInteractionEnabled(true)
    }
    
    func initGame() {
        self.score = 0
        self.gameIsOver = false
        self.isItFirstQuestion = true
        self.scoreLabel!.text = score.description
        self.currentQuestionIndex = 0
        self.highscore = UserDefaults.standard.value(forKey: "highscore") as! Int
        self.initCurrentQuestion()
    }
    
    func getRandomAnswers(howmany: Int) -> [String] {
        var result = [String]()
        var randomQuestionForAnswersList: TheQuestion!
        for _ in 1...howmany {
            let rand = Int(arc4random_uniform(UInt32(dataSource.questions.count)))
            randomQuestionForAnswersList = dataSource.questions[rand]
            ///esli imya sluchainogo sovpadaet s nashim tekushim v igre ili takoi uzhe dobavlen v spisok otvetov
            while randomQuestionForAnswersList.rightAnswerAndTitle == self.currentQuestion.rightAnswerAndTitle || result.contains(where: { $0 == randomQuestionForAnswersList.rightAnswerAndTitle }) {
                let rand = arc4random_uniform(UInt32(dataSource.questions.count))
                randomQuestionForAnswersList = dataSource.questions[Int(rand)]
            }
            result.append(randomQuestionForAnswersList.rightAnswerAndTitle)
        }
        self.currentQuestionAnswerList = result
        return result
    }
    
    func generateRightAnswer() -> Int {
        var rand = 0
        rand = Int(arc4random_uniform(UInt32(self.answerListCount)))
        self.currentQuestionAnswerList[rand] = self.currentQuestion.rightAnswerAndTitle
        self.currentQuestionRightIndex = rand
        return rand
    }
    
    
    // MARK: - player was wrong
    func playerWasWrongSkipThisQuestion() {
        currentQuestionIndex += 1
        initCurrentQuestion()
    }
    // MARK: - player was right
    func playerWasRightGoToTheNextQuestion() {
        currentQuestionIndex += 1
        initCurrentQuestion()
    }
    
    // MARK: - check right or wrong
    func checkRightOrWrong(_ answer: String) {
        /// if RIGHT
        if answer == currentQuestion.rightAnswerAndTitle {
            playSound("RIGHT")
            qVController.segmentedGradientBackChange("RIGHT")
            qVController.mainGradientBackChange("RIGHT")
            qVController.controlsInteractionEnabled(false)
            score += 1
            let beatHighScore = checkIfHighScore(score)
            if beatHighScore {
                /// pozdravit igroka s highscore, kogda on proigraet
            }
            self.scoreLabel?.text = score.description
            qVController.congratStripSetState("MIDDLE")
            let triggerTime = (Int64(NSEC_PER_SEC) * Int64(2))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
                qVController.congratStripSetState("THIRD")
                qVController.removeSegmentedControls()
                qVController.segmentedControlAnimationOnPress(gradientOnly: true)
                self.playerWasRightGoToTheNextQuestion()
                qVController.congratStripSetState("FIRST")
            })
        } else {
            /// if WRONG
            playSound("WRONG")
            qVController.segmentedGradientBackChange("WRONG")
            qVController.mainGradientBackChange("WRONG")
            qVController.controlsInteractionEnabled(false)
            qVController.congratStripLabel.backgroundColor = .red
            qVController.congratStripLabel.text = "Wrong!"
            qVController.congratStripSetState("MIDDLE")
            let triggerTime = (Int64(NSEC_PER_SEC) * Int64(2))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
                qVController.congratStripSetState("THIRD")
                qVController.removeSegmentedControls()
                qVController.segmentedControlAnimationOnPress(gradientOnly: true)
                self.playerWasWrongSkipThisQuestion()
                qVController.congratStripSetState("FIRST")
                qVController.congratStripLabel.text = "Congratulations!"
                qVController.congratStripLabel.backgroundColor = .green
                let triggerTime = (Int64(NSEC_PER_SEC) * Int64(0))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
                    qVController.doSegueWithIdentifier("showGameOver")
                })
            })
        }
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
            AudioServicesPlaySystemSound(1394)//1440)
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





