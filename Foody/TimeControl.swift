//
//  TimeControl.swift
//  Foody
//
//  Created by Giovanni Lenguito on 03/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import UIKit

class TimeControl: UIView {
    //MARK: Properties
    var time = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var buttons = [UIButton]()
    let spacing = 5
    let count = 5
    
    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        //Get icon images
        let filledImage = UIImage(named: "FilledTime")
        let emptyImage = UIImage(named: "EmptyTime")
        
        //loops count to produce the buttons
        for _ in 0 ..< count {
            //creates button
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            //add image
            button.setImage(emptyImage, for: .normal)
            button.setImage(filledImage, for: .selected)
            button.setImage(filledImage, for: [.highlighted, .selected])
            
            //Prevent additional highlight fro mshowing
            button.adjustsImageWhenHighlighted = false
            
            //adds action
            button.addTarget(self, action: #selector(TimeControl.buttonTapped(button:)), for: .touchDown)
            
            //add button to array
            buttons += [button]
            addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        //adds padding
        for (index, button) in buttons.enumerated() {
            buttonFrame.origin.x = CGFloat(index * buttonSize)
            button.frame = buttonFrame
        }
        updateStates()
    }
    
    // MARK: Actions
    func buttonTapped(button: UIButton) {
        //sets number of buttons selected
        time = buttons.index(of: button)! + 1
        updateStates()
    }
    func updateStates() {
        //Updates states
        for (index, button) in buttons.enumerated() {
            //deselect controls
            button.isSelected = index < time
        }
    }
}
