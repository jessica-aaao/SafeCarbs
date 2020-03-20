//
//  ViewController.swift
//  CALCULADORA DO DIABÉTICO
//
//  Created by Jéssica Amaral on 02/03/20.
//  Copyright © 2020 Jessica Amaral. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var labelNome: UILabel!
    @IBOutlet var labelHelloPacient: UILabel!
    @IBOutlet var labelDateText: UILabel!
    @IBOutlet var labelDatePicker: UIDatePicker!
    @IBOutlet var selectedDate: UILabel!
    @IBOutlet var labelDosisError: UILabel!
    @IBOutlet var labelWeightError: UILabel!
    @IBOutlet var labelCarbsError: UILabel!
    @IBOutlet var labelCalculate: UIButton!
    @IBOutlet var labelRecalculate: UIButton!
    @IBOutlet var labelResult: UILabel!
    
    @IBOutlet var segmentedControlInsulin: UISegmentedControl!
    @IBOutlet var segmentedControlPacient: UISegmentedControl!
    
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldDose: UITextField!
    @IBOutlet var textFieldWeight: UITextField!
    @IBOutlet var textFieldCarbs: UITextField!
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTodayDate()
        
        labelHelloPacient.isHidden = true
        labelResult.isHidden = true
        labelDosisError.isHidden = true
        labelCarbsError.isHidden = true
        labelWeightError.isHidden = true
        selectedDate.isHidden = true
        
        labelDatePicker.layer.borderWidth = 1
        labelDatePicker.layer.borderColor = UIColor.systemGray4.cgColor
        labelDatePicker.layer.backgroundColor = UIColor.white.cgColor
        labelDatePicker.layer.cornerRadius = labelDatePicker.frame.width/40
        
        textFieldName.delegate = self
        textFieldDose.delegate = self
        textFieldCarbs.delegate = self
        textFieldWeight.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action:#selector (UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setTodayDate() {
        let date = Date()
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let day = dateComponents.day!
        let month = dateComponents.month!
        let year = dateComponents.year!
        selectedDate.text = "\(day)/\(month)/\(year)"
        return
    }
    
    @IBAction func datePickerView(_ sender: UIDatePicker) {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        let day = dateComponents.day!
        let month = dateComponents.month!
        let year = dateComponents.year!
        selectedDate.text = "\(day)/\(month)/\(year)"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
       
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else{
            return
        }
        
        guard let activeField = self.activeField else{
            return
        }
        
        let keyboardFrame = keyboardSize.cgRectValue
        var screenSize: CGRect = self.view.frame
        screenSize.size.height -= (keyboardFrame.height+34)
        
        if  (!screenSize.contains(activeField.frame.origin)){
            if (self.view.frame.origin.y == 0){
                self.view.frame.origin.y -= keyboardFrame.height
            } else {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if (self.view.frame.origin.y != 0){
            self.view.frame.origin.y = 0
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.resignFirstResponder()
        view.endEditing(true)
        return true
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender == labelCalculate {
            let checkDose = textFieldDose.text ?? ""
            let checkWeight = textFieldWeight.text ?? ""
            let checkCarbs = textFieldCarbs.text ?? ""
            
            if checkDose == "" || checkWeight == "" || checkCarbs == "" {
                if checkDose == ""{
                    labelDosisError.textColor = UIColor.orange
                    labelDosisError.text = "Por favor, insira o valor da Dose de Insulina!!"
                    labelDosisError.isHidden = false
                } else {
                    labelDosisError.isHidden = true
                }
                
                if checkWeight == ""{
                    labelWeightError.textColor = UIColor.orange
                    labelWeightError.text = "Por favor, insira o seu Peso!!"
                    labelWeightError.isHidden = false
                } else {
                    labelWeightError.isHidden = true
                }
                
                if checkCarbs == "" {
                    labelCarbsError.textColor = UIColor.orange
                    labelCarbsError.text = "Por favor, insira a Quantidade de Carboidratos!!"
                    labelCarbsError.isHidden = false
                } else {
                    labelCarbsError.isHidden = true
                }
            } else {
                labelDosisError.isHidden = true
                labelWeightError.isHidden = true
                labelCarbsError.isHidden = true
                labelResult.isHidden = true
                labelDatePicker.isHidden = true
                
                selectedDate.isHidden = false
                textFieldName.isHidden = true
                let name = textFieldName.text!
                labelHelloPacient.text = name
                labelHelloPacient.isHidden = false
                               
                readInsulin()
            }
        } else {
            //limpa tudo
            labelDatePicker.isHidden = false
            selectedDate.isHidden = true
            labelResult.isHidden = true
            textFieldName.attributedText = nil
            textFieldDose.attributedText = nil
            textFieldWeight.attributedText = nil
            textFieldCarbs.text = nil
            labelHelloPacient.isHidden = true
            labelNome.isHidden = false
            textFieldName.isHidden = false
            setTodayDate()
            labelDatePicker.setDate(Date(), animated: true)
            segmentedControlInsulin.selectedSegmentIndex = 0
            segmentedControlPacient.selectedSegmentIndex = 0
            labelRecalculate.isHidden = true
        }
    }
    
    func readInsulin() {
        //Lê o que está escrito no text field dose de insulina
        var insulinDose = Float(textFieldDose.text!)!
        //Se o valor estiver em mL
        if segmentedControlInsulin.selectedSegmentIndex == 1 {
            //multiplicar valor em mL por 100 e retornar valor de insulina em UI
            insulinDose = insulinDose*100
        }
        
        calculateAll(insulinDose: Int(insulinDose))
    }
    
    func calculateAll(insulinDose: Int){
        var pacientData: Pacients
        
        pacientData = Pacients(name: String(textFieldName.text!), age: segmentedControlPacient.selectedSegmentIndex, weight: Float(textFieldWeight.text!)!, dosis: insulinDose, carbs: Float(textFieldCarbs.text!)!)
        print(pacientData)
        let result = pacientData.calculateCarbsResult()
        if result == 0.0 {
            //Printar "TUDO CERTO, PODE COMER SEM MEDO"
            labelResult.textColor = UIColor.systemGreen
            labelResult.text = "TUDO CERTO, PODE COMER SEM MEDO!!!"
            labelResult.layer.cornerRadius = labelResult.frame.width/15
            labelResult.layer.borderColor = UIColor.blue.cgColor
            labelResult.layer.borderWidth = 2
            labelResult.layer.masksToBounds = true
            labelResult.backgroundColor = UIColor.white
            labelResult.isHidden = false
            labelRecalculate.isHidden = false
        } else {
            //Printar "VOCE NECESSITA DE MAIS X UI DE INSULINA"
            labelResult.layer.cornerRadius = labelResult.frame.width/15
            labelResult.layer.borderWidth = 2
            labelResult.layer.borderColor = UIColor.blue.cgColor
            labelResult.layer.masksToBounds = true
            labelResult.backgroundColor = UIColor.white
            if segmentedControlInsulin.selectedSegmentIndex == 1 {
                let newInsulin = result/100
                labelResult.textColor = UIColor.systemRed
                labelResult.text = String(format: "Você necessita de mais %.1f mL de insulina!!", newInsulin)
            } else {
                labelResult.textColor = UIColor.systemRed
                labelResult.text = "Você necessita de mais \(result) UI de insulina!!"
            }
            //Mostrar botão converter para mL
            labelResult.isHidden = false
            labelRecalculate.isHidden = false
        }
    }
}
