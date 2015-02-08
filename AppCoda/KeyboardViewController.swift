//
//  KeyboardViewController.swift
//  Appcoda Keyboard
//
//  Created by Joyce Echessa on 10/27/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

// TODO: enlarge backspace
// TODO: unicode chars for control keys

import UIKit

class KeyboardViewController: UIInputViewController {
    
    var capsLockOn = true
    
    @IBOutlet weak var row1: UIView!
    @IBOutlet weak var row2: UIView!
    @IBOutlet weak var row3: UIView!
    @IBOutlet weak var row4: UIView!
    
    @IBOutlet weak var autocompleteRow: UIView!
    @IBOutlet weak var autocomplete1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiateWithOwner(self, options: nil)
        view = objects[0] as UIView;
    }
    
    @IBAction func nextKeyboardPressed(button: UIButton) {
        advanceToNextInputMode()
    }
    
    @IBAction func capsLockPressed(button: UIButton) {
        capsLockOn = !capsLockOn
        
        changeCaps(row1)
        changeCaps(row2)
        changeCaps(row3)
        changeCaps(row4)
    }
    
    @IBAction func keyPressed(button: UIButton) {
        var string = button.titleLabel!.text
        
        // Turn off CAPS if one is typed
        if countElements(string!) == 1 {
            if capsLockOn {
                capsLockPressed(button)
            }
        }
        
        (textDocumentProxy as UIKeyInput).insertText("\(string!)")
        
        UIView.animateWithDuration(0.2, animations: {
            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.0, 2.0)
            }, completion: {(_) -> Void in
                button.transform =
                    CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
        })
        updateAutocomplete()
    }
    
    @IBAction func backSpacePressed(button: UIButton) {
        (textDocumentProxy as UIKeyInput).deleteBackward()
    }
    
    @IBAction func spacePressed(button: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText(" ")
    }
    
    @IBAction func returnPressed(button: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText("\n")
    }
    
    @IBAction func charSetPressed(button: UIButton) {
    }
    
    @IBAction func autocompletePressed(sender: UIButton) {
        while (textDocumentProxy as UIKeyInput).hasText() {
            (textDocumentProxy as UIKeyInput).deleteBackward()
        }
        keyPressed(sender)
        (textDocumentProxy as UIKeyInput).insertText(" ")
    }
    
    func changeCaps(containerView: UIView) {
        for view in containerView.subviews {
            if let button = view as? UIButton {
                let buttonTitle = button.titleLabel!.text
                if capsLockOn {
                    let text = buttonTitle!.uppercaseString
                    button.setTitle("\(text)", forState: .Normal)
                } else {
                    let text = buttonTitle!.lowercaseString
                    button.setTitle("\(text)", forState: .Normal)
                }
            }
        }
    }
    
    // MARK: Demo
    
    func updateAutocomplete() {
        let context = (textDocumentProxy as UITextDocumentProxy).documentContextBeforeInput.lowercaseString
        if let completion = completionDictionary[context] {
            autocomplete1.setTitle(completion, forState: .Normal)
        } else {
            for (suffix, completion) in suffixDictionary {
                if context.hasSuffix(suffix) {
                    autocomplete1.setTitle(completion, forState: .Normal)
                }
            }
        }
    }
    
    var completionDictionary: [String: String] {
        return ["mm": "Mm Mm Good",
            "mm id like": "I like you",
            "mm id like to swipe": "swipe my heart",
            "mm id like to swipe right on": "on your honor",
            "yeah im": "Yeah, i’m hungry",
            "yeah im starving": "would love to eat",
            "yeah im starving lemme": "let me see",
            "yeah im starving lemme see that": "diners nearby",
            "def": "Definitely yours",
            "def but my": "but my darling",
            "def but my favorite game": "favorite game is you",
            "def but my favorite game is just the": "just the best",
            "im": "I am",
            "im w": "working out",
            "im wearing edible p": "doing pilates",
            "ok": "Okay",
            "ok but i like": "but I like you",
            "i had": "I had a good time",
            "i had chlam": "clams casino",
            "i had chlamydia but now its": "but now it’s nice of you",
            "i want you": "I want you",
            "i want you to f": "to find me"]
    }
    
    var suffixDictionary: [String: String] {
        return ["your abs": "Hey! Do you want to make plans?",
            "that d": "I’m famished! What’s your favorite tea?",
            "the tip": "You sunk my battleship!",
            "panties": "I work at a local food pantry.",
            "rough": "I have a great relationship with my parents.",
            "cleared up": "Tell me a secret.",
            "bang me": "I love fingerpainting!"]
    }
    
}
