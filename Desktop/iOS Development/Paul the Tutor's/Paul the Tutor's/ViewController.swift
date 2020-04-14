//
//  ViewController.swift
// 
//

import UIKit

class ViewController: UIViewController {
    
    //Place your instance variables here
    let subtractionQuestions = QuestionBank(questions:[
        Question.init(text: "What is 4 - 4?", correctAnswer: "0"),
        Question.init(text: "What is 53 - 22?", correctAnswer: "31"),
        Question.init(text: "What is 37 - 9?", correctAnswer: "28"),
        Question.init(text: "What is 4 - 12?", correctAnswer: "-8"),
        Question.init(text: "What is -23 - (-1)?", correctAnswer: "-22"),
        Question.init(text: "What is 44 - 4?", correctAnswer: "40"),
        Question.init(text: "What is 9 - 17?", correctAnswer: "-8"),
        Question.init(text: "What is 17 - 38?", correctAnswer: "-21"),
        Question.init(text: "What is 231 - 743?", correctAnswer: "-512"),
        Question.init(text: "What is -95 - 32?", correctAnswer: "-127")

    ])
    let additionQuestions = QuestionBank(questions:[
        Question.init(text: "What is 4 + 4?", correctAnswer: "8"),
        Question.init(text: "What is 12 + 43?", correctAnswer: "55"),
        Question.init(text: "What is -8 + 4?", correctAnswer: "-4"),
        Question.init(text: "What is 3 + 23?", correctAnswer: "26"),
        Question.init(text: "What is 17 + 25?", correctAnswer: "42"),
        Question.init(text: "What is 45 + -10?", correctAnswer: "35"),
        Question.init(text: "What is 7 + 17?", correctAnswer: "24"),
        Question.init(text: "What is 99 + 33?", correctAnswer: "132"),
        Question.init(text: "What is -65 + -32?", correctAnswer: "-97"),
        Question.init(text: "What is 0 + -9?", correctAnswer: "-9")
    ])
    var qb: QuestionBank!
    var pickedAnswer : String = ""
    var questionNumber : Int = 0
    var score: Int = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var secButton: UIButton!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var checkAnswer: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        startUI()//display first screen
    }


    @IBAction func answerPressed(_ sender: AnyObject) {
        if sender.tag < 3 {
            if sender.tag == 1 {
                qb = additionQuestions
            }
            else if sender.tag == 2 {
                qb = subtractionQuestions
            }
            toggleView()
            updateUI(qs: qb)
            nextQuestion(qs: qb)
        }
        else{
            checkCurrAnswer(qs: qb)
            questionNumber += 1
            updateUI(qs: qb)
            if(questionNumber < qb.list.count){
                nextQuestion(qs: qb)
            }
            else{
                let alert = UIAlertController(title: "Awesome!", message: "Press the button below to restart.", preferredStyle: .alert)

                let action = UIAlertAction(title: "Restart", style: .default) { (UIAlertAction) in
                    self.startOver()
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }

    }
    func startUI() {
        scoreLabel.text = "Score: \(score)"
        questionLabel.text = "Addition or Subtraction?"
        mainButton.setTitle("Addition", for: .normal)
        secButton.setTitle("Subtraction", for: .normal)
        answerField.text = ""
        toggleView()
        questionLabel.isHidden = false
        mainButton.isHidden = false
        secButton.isHidden = false
    }

    func updateUI(qs: QuestionBank) {
        scoreLabel.text = "Score: \(score)"
        progressLabel.text = "\(questionNumber)/\(qs.list.count)"
        progressBar.progress = (Float(questionNumber) / Float(qs.list.count))
    }


    func nextQuestion(qs: QuestionBank) {//true for addition and false for subtractions
        questionLabel.text = qs.list[questionNumber].text
        answerField.text = ""
    }


    func checkCurrAnswer(qs: QuestionBank) {
        let correctAnswer = qs.list[questionNumber].answer
        if answerField.text == correctAnswer {
            ProgressHUD.showSuccess("Correct!")
            score += 1
        }
        else {
            ProgressHUD.showError("Wrong!")
        }
    }


    func startOver() {
        questionNumber = 0
        score = 0
        startUI()
    }

    func toggleView(){
        answerField.isHidden = !answerField.isHidden
        scoreLabel.isHidden = !scoreLabel.isHidden
        progressBar.isHidden = !progressBar.isHidden
        progressLabel.isHidden = !progressLabel.isHidden
        checkAnswer.isHidden = !checkAnswer.isHidden
        mainButton.isHidden = !mainButton.isHidden
        secButton.isHidden = !secButton.isHidden
    }

    
}
