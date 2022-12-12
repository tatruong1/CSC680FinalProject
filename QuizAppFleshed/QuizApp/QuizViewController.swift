//
//  ViewController.swift
//  QuizApp
//
//  Created by JPL-ST-SPRING2022 on 9/11/22.
//

import UIKit

//Allows us to define structures of related types
protocol QuestionType {
    //All properties in protocols must be var
    //Should also declare if they have getters & setters
    var prompt: String { get }
}

//Our 1st model
struct FlashCard: QuestionType {
    var prompt: String
}

struct TrueOrFalseQuestion: QuestionType {
    var prompt: String
    var statementIsTrue: Bool
}

struct MultipleChoiceQuestion: QuestionType {
    var prompt: String
    var correctAnswer: String
    var answerA: String
    var answerB: String
    var answerC: String
    var answerD: String
}

//MVC: Model View Control
//Syntax for inheritance and protocol conformance is the same
//If req. both, protocol conform comes 2nd, separated by a comma
class QuizViewController: UIViewController, AddQProtocol { //,QuestionType
    
    //This tells what type is allowed in array (QuestionType)
    //Want to avoid using [Any] as much as possible
    var questionBank: [QuestionType] = [
        FlashCard(prompt: "With UIKit, you can use interface builder to create views visually."),
        TrueOrFalseQuestion(prompt:"Arrays can hold different types", statementIsTrue: false),
        MultipleChoiceQuestion(prompt:"10%3=?",
            correctAnswer:"C",
            answerA: "1/3",
            answerB: "0",
            answerC: "1",
            answerD: "7")
    ]
    var currentQuestionIndex = 0
        
    var shuffle = true
    
    @IBOutlet weak var prompt: UILabel!
    
    @IBOutlet weak var flashCardView: UIView!
    @IBOutlet weak var trueFalseView: UIView!
    
    @IBOutlet weak var multiChoiceView: UIView!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    @IBOutlet weak var indicator: UILabel!
    
    @IBAction func toggleShuffle(_ sender: UISwitch) {
        shuffle = !shuffle
    }
    
    @IBAction func deleteQuestion(_ sender: UIButton) {
        if(questionBank.count > 1) {
            questionBank.remove(at: currentQuestionIndex)
            currentQuestionIndex -= 1
            showNextQuestion()
        } else {
            showErrorState()
            prompt.text = "Min. 1 Question Req."
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                prompt.text = questionBank[currentQuestionIndex].prompt
            }
        }
    }
    //IB stands for Interface Builder
    @IBAction func quizButtonClicked(_ sender: UIButton) {
        //prompt.text = "Button pressed: \(sender.tag)"
        if(shouldQuestionAdvance(buttonTag: sender.tag)) {
            showNextQuestion()
        } else {
            showErrorState()
        }
    }
    
    //returns bool
    func shouldQuestionAdvance(buttonTag: Int) -> Bool {
        let currentQuestion: QuestionType = questionBank[currentQuestionIndex]
        //If we can turn the currentquestion into a FlashCard, assign it to flashCard & run the codeblock
        //i.e. if the cast is successful, run the codeblock
        if currentQuestion is FlashCard {
            return true
        } else if let trueFalseQuestion: TrueOrFalseQuestion = currentQuestion as? TrueOrFalseQuestion {
            //returns true if 'TRUE' button is pressed, else return false
            //False is tag0, True is tag1
            if(trueFalseQuestion.statementIsTrue && buttonTag == 1) {
                showCorrect()
                return true
            }else if(!trueFalseQuestion.statementIsTrue && buttonTag == 0) {
                showCorrect()
                return true
            }
            else {
                return false
            }
            //trueFalseQuestion.statementIsTrue
        } else if let multiChoiceQuestion: MultipleChoiceQuestion = currentQuestion as? MultipleChoiceQuestion {
            //A-0,C-1,B-2,D-3
            switch buttonTag {
                case 0:
                    if( multiChoiceQuestion.correctAnswer == "A") {
                        showCorrect()
                        return true
                    }
                    break
                case 1:
                    if( multiChoiceQuestion.correctAnswer == "C") {
                        showCorrect()
                        return true
                }
                    break
                case 2:
                    if( multiChoiceQuestion.correctAnswer == "B") {
                        showCorrect()
                        return true
                }
                    break
                default:
                    if( multiChoiceQuestion.correctAnswer == "D") {
                        showCorrect()
                        return true
                }
                    break
            }
            return false
        } else {
            //bad approach, can't catch programming mistake until runtime
        }
        return true
    }
    
    func showErrorState() {
        indicator.backgroundColor = .red
        indicator.textColor = .red
        
        //After a delay, turn indicator back to black
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            indicator.backgroundColor = .black
            indicator.textColor = .black
        }
    }
    func showCorrect() {
        indicator.backgroundColor = .green
        indicator.textColor = .green
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            indicator.backgroundColor = .black
            indicator.textColor = .black
        }
    }
    
    func showNextQuestion() {
        currentQuestionIndex += 1
        if(currentQuestionIndex >= questionBank.count) {
            currentQuestionIndex = 0
            if(shuffle) {
                questionBank = questionBank.shuffled()
            }
        }
        updateView()
    }
    func updateView() {
        //prompt.text = questionBank[currentQuestionIndex].prompt
        //prompt.backgroundColor = .gray
        
        flashCardView.isHidden = true
        trueFalseView.isHidden = true
        multiChoiceView.isHidden = true
        let currentQuestion: QuestionType = questionBank[currentQuestionIndex]
        //If we can turn the currentquestion into a FlashCard, assign it to flashCard & run the codeblock
        //i.e. if the cast is successful, run the codeblock
        if currentQuestion is FlashCard {
            showFlashCard()
        } else if currentQuestion is TrueOrFalseQuestion {
            showTrueFalse()
        } else if currentQuestion is MultipleChoiceQuestion{
            showMultiChoice()
        } else {
            //bad approach, can't catch programming mistake until runtime
            prompt.text = "ERROR"
        }
    }
    
    func showTrueFalse() {
        prompt.text = questionBank[currentQuestionIndex].prompt
        trueFalseView.isHidden = false

    }
    func showFlashCard() {
        prompt.text = questionBank[currentQuestionIndex].prompt
        flashCardView.isHidden = false

    }
    func showMultiChoice() {
        prompt.text = questionBank[currentQuestionIndex].prompt
        multiChoiceView.isHidden = false
        
        //Changes button label to display diff answers
        let currentQ: QuestionType = questionBank[currentQuestionIndex]
        if let tempQ: MultipleChoiceQuestion = currentQ as? MultipleChoiceQuestion {
            buttonA.setTitle(tempQ.answerA, for: .normal)
            buttonB.setTitle(tempQ.answerB, for: .normal)
            buttonC.setTitle(tempQ.answerC, for: .normal)
            buttonD.setTitle(tempQ.answerD, for: .normal)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        // Do any additional setup after loading the view.
    }
    //From AddQ to here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addQViewController = segue.destination as? AddQViewController {
            addQViewController.delegate = self
        }
    }
    //User custom questions!
    func addQ(question: QuestionType) {
        questionBank.append(question)
    }
}

