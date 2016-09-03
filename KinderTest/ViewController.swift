//
//  ViewController.swift
//  KinderTest
//
//  Created by Joe Pichardo on 8/28/16.
//  Copyright © 2016 Joe Pichardo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let numberedImages = ["number-0", "number-1", "number-2", "number-3"] // array of names for images used
    
    var currentImageIndex = 0

    // buttons for images
    @IBOutlet var currentButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    // contraints used for animation
    @IBOutlet var currentButtonCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var nextButtonCenterXConstraint: NSLayoutConstraint!
    
    
    // MARK: Functions when app opens
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // adds the image to button at current index
        let nextNumberImage = UIImage(named: numberedImages[currentImageIndex])
        currentButton.setImage(nextNumberImage, forState: UIControlState.Normal)
        
        updateOffScreenButtonRight()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set button's initial alpha
        nextButton.alpha = 0 // button is not visible
    }
    
    
    // MARK: Button Actions
    
    // Next two methods go through the array of strings(name of images used)
    @IBAction func nextButtonPressed(sender: UIButton) {
        currentImageIndex += 1// goes forward in array, if limit is reached go to the beginning
        if currentImageIndex == numberedImages.count {
            currentImageIndex = 0
        }
        
        // adds the image to button at current index
        let nextNumberImage = UIImage(named: numberedImages[currentImageIndex])
        nextButton.setImage(nextNumberImage, forState: UIControlState.Normal)
        
        // prevent first animation in the wrong direction
        if nextButtonCenterXConstraint.constant > 0{
            
            swap(&self.currentButton,
                 &self.nextButton)
            swap(&self.currentButtonCenterXConstraint,
                 &self.nextButtonCenterXConstraint)
            
            let screenWidth = view.frame.width
            nextButtonCenterXConstraint.constant = -screenWidth
            nextButton.setImage(nextNumberImage, forState: UIControlState.Normal)
        }
        animateImageTransitionsRight()
    }
    
    
    @IBAction func previousButtonPressed(sender: UIButton) {
        currentImageIndex -= 1 // goes backwards in array, if limit is reached go to the end
        if currentImageIndex < 0 {
            currentImageIndex = numberedImages.count - 1
        }
        
        // adds the image to button at current index
        let nextNumberImage = UIImage(named: numberedImages[currentImageIndex])
        nextButton.setImage(nextNumberImage, forState: UIControlState.Normal)
        
        // prevent first animation in the wrong direction
        if nextButtonCenterXConstraint.constant < 0{
            
            swap(&self.currentButton,
                 &self.nextButton)
            swap(&self.currentButtonCenterXConstraint,
                 &self.nextButtonCenterXConstraint)
            
            let screenWidth = view.frame.width
            nextButtonCenterXConstraint.constant = +screenWidth
            
            nextButton.setImage(nextNumberImage, forState: UIControlState.Normal)
        }
        
        
        animateImageTransitionsLeft()
        
    }
    
    // MARK: Animations and their helpers
    
    func updateOffScreenButtonRight() {
        //moves next button off screen to help animate a transition in
        let screenWidth = view.frame.width
        nextButtonCenterXConstraint.constant = -screenWidth
    }
    func updateOffScreenButtonLeft() {
        //moves next button off screen to help animate a transition in
        let screenWidth = view.frame.width
        nextButtonCenterXConstraint.constant = +screenWidth
    }
    
    // animates button translation to the right
    func animateImageTransitionsRight(){
        
        //Force any outstanding layout changes to occur
        self.view.layoutIfNeeded()
        
        // Center the X contraints
        let screenWidth = view.frame.width
        self.nextButtonCenterXConstraint.constant = 0
        self.currentButtonCenterXConstraint.constant += screenWidth
        
        // Animate the alpha
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   options: [.CurveLinear],
                                   animations: {
                                    self.currentButton.alpha = 0
                                    self.nextButton.alpha = 1
                                    
                                    self.view.layoutIfNeeded() // recalculate frames, b/c contraint moved
            },
            // accepts two references and swaps them
            completion: { _ in
                swap(&self.currentButton,
                    &self.nextButton)
                swap(&self.currentButtonCenterXConstraint,
                    &self.nextButtonCenterXConstraint)
                
                self.updateOffScreenButtonRight()
        })
    }
    
    // animates button translation to the left
    func animateImageTransitionsLeft(){
        
        //Force any outstanding layout changes to occur
        self.view.layoutIfNeeded()
        
        // Center the X contraints
        let screenWidth = view.frame.width
        self.nextButtonCenterXConstraint.constant = 0
        self.currentButtonCenterXConstraint.constant -= screenWidth
        
        // Animate the alpha
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   options: [.CurveLinear],
                                   animations: {
                                    self.currentButton.alpha = 0
                                    self.nextButton.alpha = 1
                                    
                                    self.view.layoutIfNeeded() // recalculate frames, b/c contraint moved
            },
            // accepts two references and swaps them
            completion: { _ in
                swap(&self.currentButton,
                    &self.nextButton)
                swap(&self.currentButtonCenterXConstraint,
                    &self.nextButtonCenterXConstraint)
                
                self.updateOffScreenButtonLeft()
        })
        
    }

}

