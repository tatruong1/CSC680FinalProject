import Foundation
import UIKit

protocol AddQProtocol {
    func addQ(question: QuestionType)
}
class AddQViewController: UIViewController {
    var delegate: AddQProtocol?
    
    var tempFlash = FlashCard(prompt:"testF")
    var tempTF = TrueOrFalseQuestion(prompt: "testTF", statementIsTrue: true)
    var tempMulti = MultipleChoiceQuestion(prompt: "testM", correctAnswer: "A", answerA: "A", answerB: "B", answerC: "C", answerD: "D")
    
    @IBOutlet weak var customPrompt: UITextField!
    
    
    @IBOutlet weak var TFView: UIView!
    @IBOutlet weak var isPromptTrue: UISwitch!
    
    @IBOutlet weak var MultiView: UIView!
    @IBOutlet weak var correctMulti: UISegmentedControl!
    @IBAction func multiChange(_ sender: Any) {
        switch correctMulti.selectedSegmentIndex {
        case 0:
            tempMulti.correctAnswer = "A"
            break
        case 1:
            tempMulti.correctAnswer = "D"
            break
        case 2:
            tempMulti.correctAnswer = "C"
            break
        default:
            tempMulti.correctAnswer = "D"
            break
        }
    }
    @IBOutlet weak var inputA: UITextField!
    @IBOutlet weak var inputB: UITextField!
    @IBOutlet weak var inputC: UITextField!
    @IBOutlet weak var inputD: UITextField!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func ChangeQType(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                TFView.isHidden = true
                MultiView.isHidden = true
                break
            case 1:
                TFView.isHidden = false
                MultiView.isHidden = true
                break
            default:
                TFView.isHidden = true
                MultiView.isHidden = false
                break
        }
    }
    @IBOutlet weak var AddQOutlet: UIButton!
    @IBAction func AddQButton(_ sender: UIButton) {
        //delegate?.addQ(question: tempMulti)
        switch segmentedControl.selectedSegmentIndex {
            //Flash
            case 0:
                tempFlash.prompt = customPrompt.text!
            
                delegate?.addQ(question: tempFlash)
                break
            //TF
            case 1:
                tempTF.prompt = customPrompt.text!
                tempTF.statementIsTrue = isPromptTrue.isOn
            
                delegate?.addQ(question: tempTF)
                break
            //Multi
            default:
                tempMulti.prompt = customPrompt.text!
                tempMulti.answerA = inputA.text!
                tempMulti.answerB = inputB.text!
                tempMulti.answerC = inputC.text!
                tempMulti.answerD = inputD.text!
            
                delegate?.addQ(question: tempMulti)
                break
        }
        AddQOutlet.setTitle("Appended", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            AddQOutlet.setTitle("Add", for: .normal)
        }
    }
    
}
