//
//  ViewController.swift
//  The Chalkboard Calculator
//
//  Created by anthony on 8/27/17.
//  Copyright © 2017 Casandra Hayward. All rights reserved.
//

import UIKit



class CalculatorViewController: UIViewController {
    
   //MARK: -Properties
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var accumulatorLabel: UILabel!
    @IBOutlet weak var currentCalculatingLabel: UILabel!
    @IBOutlet weak var questionButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
let numberFormatting = NumberFormatter()
    
    var usesSignificantDigits = true
    
    var currentCalculatingLabelHasADecimal = false
    var isInTheMiddleOfAnOperation = false
    var currentOperation: String?
    var number1: Double?
    var number2: Double?
    var numberIsOnLabelFromOperation = false
    var accumulator: Double? = 0.00
    var digits:[Character] = []
    
    

   
 
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //round layer corners
        scrollView.layer.masksToBounds = true
        scrollView.layer.cornerRadius = 10
        accumulatorLabel.layer.masksToBounds = true
        accumulatorLabel.layer.cornerRadius = 10
        currentCalculatingLabel.layer.masksToBounds = true
        currentCalculatingLabel.layer.cornerRadius = 10
        
        //add border width to scroll view
        scrollView.layer.borderWidth = 5.00
        scrollView.layer.borderColor = UIColor.white.cgColor
        
        
        //add border color and width to labels
        let whitePaternToUse = UIColor.white.cgColor
        accumulatorLabel.layer.borderWidth = 5.00
        currentCalculatingLabel.layer.borderWidth = 5.00
        accumulatorLabel.layer.borderColor = whitePaternToUse
        currentCalculatingLabel.layer.borderColor = whitePaternToUse
        
        //add border width and color to view layer
        view.layer.borderWidth = 5.0
        view.layer.borderColor = whitePaternToUse
        
        //Adds an initial value for the three labels when screen first loads.
        accumulatorLabel.text = "0.00"
        historyLabel.text = "0.00"
        currentCalculatingLabel.text = " "
    
       usesSignificantDigits = true
        
        numberFormatting.maximumFractionDigits = 4
        
    }
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//MARK: - Actions
    
    @IBAction func unwindToCalculator(sender: UIStoryboardSegue) {
        let _ = sender.source as? CalculatorViewController
        
    }
    
    
    //User presses decimal
    //If the digits being displayed on resultLabel already has a decimal,return.  Otherwise, the  numberAlreadyHasADecimal property should be set to true.  This ensures that only one decimal is entered within a number.
    @IBAction func addDecimal(_ sender: UIButton) {
      
        guard let decimal = sender.currentTitle else {return}
        
        //Change property to true because a decimal will be added
        currentCalculatingLabelHasADecimal = true
        
        
        guard let valueFromCurrentCalculatingLabel = currentCalculatingLabel.text else {return}
        
        if valueFromCurrentCalculatingLabel.contains(decimal) {
            return
        }else{
            
            currentCalculatingLabel.text = currentCalculatingLabel.text! + decimal
            
            
        }
        
        
        }
    
    
    //User presses a button that is an operation which takes all the digits from the currentCalculatingLabel and creates a number
    @IBAction func performOperation(_ sender: UIButton) {
        
        guard let operation = sender.currentTitle else {return}
        currentOperation = operation
        currentCalculatingLabelHasADecimal = false
        isInTheMiddleOfAnOperation = true
        numberIsOnLabelFromOperation = false
        
        if isInTheMiddleOfAnOperation {
            
            //current label no value
            
            if currentCalculatingLabel.text == " " {
                currentCalculatingLabel.text = currentOperation
                
                historyLabel.text = "\(number1!)" + " " + currentOperation!
                currentCalculatingLabel.text = String(number1!)
                
                return
                
            }else {
                
                //current label has a value
            
                if number1 == nil && accumulator == nil{
                    
                    //number 1 has to come from digits on label
                    guard let numberFromDigitsOnCurrentCalculatingLabel = currentCalculatingLabel.text else {return}
                    guard let numberFromDigits = Double(numberFromDigitsOnCurrentCalculatingLabel) else {return}
                    number1 = numberFromDigits
                    
                    
                    historyLabel.text = "\(number1!)" + " " + currentOperation!
                    numberIsOnLabelFromOperation = true
                }
                
                if number1 == nil && accumulator != nil {
                    
                    //number 1 comes from digits on label
                    guard let numberFromDigitsOnCurrentCalculatingLabel = currentCalculatingLabel.text else {return}
                    guard let numberFromDigits = Double(numberFromDigitsOnCurrentCalculatingLabel) else {return}
                    number1 = numberFromDigits
                    
                    
                    historyLabel.text = "\(number1!)" + " " + currentOperation!
                    currentCalculatingLabel.text = String(number1!)
                    
                        numberIsOnLabelFromOperation = true
                    //number1 filled and 2 empty first time
                }else if number1 != nil && number2 == nil {
                    
                    if accumulator == 0.0 {
                        
                        //get the 2nd # from current label
                        guard let numberFromDigitsOnCurrentCalculatingLabel = currentCalculatingLabel.text else {return}
                        guard let numberFromDigits = Double(numberFromDigitsOnCurrentCalculatingLabel) else {return}
                        number2 = numberFromDigits
                        
                        //update labels
                        historyLabel.text = "\(number1!)" + " " + currentOperation!
                        currentCalculatingLabel.text = String(number2!)
                        //accumulatorLabel.text = String(accumulator)
                        
                        
                        numberIsOnLabelFromOperation = true
                        
                        //switch on operation symbol to determine which operation to perform
                        switch operation {
                        case "+": accumulator = number1! + number2!
                            
                        default : return
                            
                        }
                        
                        //no longer in the middle of an operation
                        isInTheMiddleOfAnOperation = false
                        
                        //reset numbers to nil
                        number1 = nil
                        number2 = nil
                        
                        //currentCalculatingLabel.text = "\(accumulator)"
                        historyLabel.text = "\(number1!) \(operation)  \(number2!)"
                     
                        
                        
                    }else{
                        //accumulator is not nil, so 2nd number is the accumulator
                        number2 = accumulator
                        
                        
                        
                        
                        switch operation {
                        case "+": accumulator = number1! + number2!
                            
                        default : return
                            
                        }
                        
                        print("exit operation accumulator\(isInTheMiddleOfAnOperation)")
                         isInTheMiddleOfAnOperation = false
                    number1 = nil
                    number2 = nil
                        currentCalculatingLabel.text = " "
                        historyLabel.text = "\(number1!)  \(number2!)"
                    }
                    
                }
            }
        }else {
                    
                   
                    
                }
                
                
                print("exit perform operation\(isInTheMiddleOfAnOperation)")
            }
        
    @IBAction func addDigitToCurrentCalculatingLabel(_ sender: UIButton) {
        if digits.count > 12 {return}
        //Unwrap the title of the sender parameter (UIButton that user tapped).  Use the currentTitle property to get the digit (UIButon that the user tapped) which is used to make the number.
        guard let digit = sender.currentTitle else {return}
       
        
        //if a number is on calculating label then clear label
        if numberIsOnLabelFromOperation {
            
            currentCalculatingLabel.text = " "
            currentCalculatingLabel.text = digit
            numberIsOnLabelFromOperation = false
            
            
            
            //if 0 is on calc label as the leading digit always remove before adding other digits
        }else if currentCalculatingLabel.text == "0" {
            currentCalculatingLabel.text = digit
            
            

        
        //Append the digit to the currentCalculatingLabel that displays the digits.  As user types a digit, the digits are appended to the resultLabel to make a number until the user taps an operation button.
        }else if currentCalculatingLabel.text == " " {
            
            
            currentCalculatingLabel.text  =  String(digit)
            
            
            
        } else {
            
            currentCalculatingLabel.text = currentCalculatingLabel.text! + digit
            
            
        }
        
        
    }
    
    //MARK: - Save and Load
    func saveCalculatorData() {
        
        
    }
    
    func loadCalculatorHistory() {
        
    }
    
    //MARK: - Helper Functions
    func backspaceButtonTapped() {
        
    }
    
    func clearLastButtonTapped() {
        
    }
    
    func goToFractionMode() {
        
    }
 
    
    }

