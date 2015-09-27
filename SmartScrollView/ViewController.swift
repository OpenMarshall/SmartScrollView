//
//  ViewController.swift
//  SmartScrollView
//
//  Created by 徐开源 on 15/9/21.
//  Copyright © 2015年 徐开源. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Constant & Variable
    let scrollTitle = UIScrollView()
    let scrollContent = UIScrollView()
    let titles = ["iPod","iPad","iPhone","iMac","MacBook","Mac mini","Mac Pro"]
    let titlesWidth:[CGFloat] = [34,33,53,37,72,69,63] // Up to how long a UILabel would be to show a specific word
    var titleLabels:[UILabel] = [UILabel]() // Store all the UILabels in scrollTitle
    var titleIndicator:[UIView] = [UIView]() // Store the UIView in scrollTitle
    
    // MARK: - Main Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.Creat ScorllView
        self.scrollTitle.frame = CGRectMake(0, 0, self.view.frame.width, 40)
        self.scrollContent.frame = CGRectMake(0, 40, self.view.frame.width, self.view.frame.height-40)

        self.scrollTitle.backgroundColor = UIColor(red:0.23, green:0.51, blue:0.85, alpha:1)
        
        self.scrollContent.pagingEnabled = true
        
        self.scrollTitle.showsHorizontalScrollIndicator = false
        self.scrollContent.showsHorizontalScrollIndicator = false
        
        self.scrollTitle.delegate = self
        self.scrollContent.delegate = self
        
        self.view.addSubview(self.scrollTitle)
        self.view.addSubview(self.scrollContent)
        
        //2.Add Content
        
        // Part I - ScrollTitle
        var tempX:CGFloat = 0
        for var i = 0; i < titles.count; i++ {
            
            let label = UILabel(frame: CGRectMake(tempX+15, 10, titlesWidth[i], 21))
            tempX = tempX + 30 + titlesWidth[i]
            label.text = titles[i]
            label.textAlignment = NSTextAlignment.Center
            label.adjustsFontSizeToFitWidth = true
            label.userInteractionEnabled = true
            label.textColor = UIColor.grayColor()
            if i == 0 {
                label.textColor = UIColor.blackColor() // "iPod"'s Initial Color is Black, others' are Gray
            }
            
            // Add Tap Gesture
            if i == 0 {
                let tap = UITapGestureRecognizer()
                label.addGestureRecognizer(tap)
                tap.addTarget(self, action: "tapped0")
            }else if i == 1 {
                let tap = UITapGestureRecognizer()
                label.addGestureRecognizer(tap)
                tap.addTarget(self, action: "tapped1")
            }else if i == 2 {
                let tap = UITapGestureRecognizer()
                label.addGestureRecognizer(tap)
                tap.addTarget(self, action: "tapped2")
            }else if i == 3 {
                let tap = UITapGestureRecognizer()
                label.addGestureRecognizer(tap)
                tap.addTarget(self, action: "tapped3")
            }else if i == 4 {
                let tap = UITapGestureRecognizer()
                label.addGestureRecognizer(tap)
                tap.addTarget(self, action: "tapped4")
            }else if i == 5 {
                let tap = UITapGestureRecognizer()
                label.addGestureRecognizer(tap)
                tap.addTarget(self, action: "tapped5")
            }else if i == 6 {
                let tap = UITapGestureRecognizer()
                label.addGestureRecognizer(tap)
                tap.addTarget(self, action: "tapped6")
            }
            
            self.titleLabels.append(label)
            self.scrollTitle.addSubview(label)
        }
        
        let indicator = UIView(frame: CGRectMake(15, 35, titlesWidth[0], 5))
        indicator.backgroundColor = UIColor(red:0.04, green:0.31, blue:0.62, alpha:1)
        self.titleIndicator.append(indicator)
        self.scrollTitle.addSubview(indicator)
        
        // Part II - ScrollContent
        var tempX2:CGFloat = 0
        for var i = 0; i < titles.count; i++ {
            
            let imageView = UIImageView(frame: CGRectMake(tempX2, 0, self.view.frame.width, self.view.frame.height-40))
            imageView.image = UIImage(named: titles[i])
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            if titles[i] == "iPad" {
                imageView.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1)
            }else if titles[i] == "iPhone"{
                imageView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
            }else if titles[i] == "MacBook"{
                imageView.backgroundColor = UIColor(red:0.99, green:0.99, blue:0.99, alpha:1)
            }else if titles[i] == "Mac Pro"{
                imageView.backgroundColor = UIColor.blackColor()
            }else{
                imageView.backgroundColor = UIColor.whiteColor()
            }
            tempX2 += self.view.frame.width
            
            self.scrollContent.addSubview(imageView)
        }
        
        //3.Set Content Size
        self.scrollTitle.contentSize = CGSizeMake(tempX, 0)
        self.scrollContent.contentSize = CGSizeMake(tempX2, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Detect Scroll Action
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Variable
        let x = scrollView.contentOffset.x
        let width = self.view.frame.width
        // Scroll
        if scrollView == self.scrollTitle{
        }
        if scrollView == self.scrollContent{
            // Variable
            let index:Int = Int( (x + width/2)/width ) // Main Page Index When Scroll
            var min:Int = Int(ceil( x/width )) - 1 // Left Page Index When Scroll
            var max:Int = min + 1 // Right Page Index When Scroll
            let mid:CGFloat = x/width // Scroll Point

            var offset:CGFloat = 0
            for var i = 0; i <= index; i++ {
                offset += 30 + titlesWidth[i]
            }
            
            // Label Color Change
            for label:UILabel in self.titleLabels {
                if min < 0 {
                    min = 0
                    self.view.backgroundColor = UIColor.whiteColor() // ensure backgroundColor behaves like the "iPod" picture
                }
                if max >= titles.count {
                    max = titles.count - 1
                    self.view.backgroundColor = UIColor.blackColor() // ensure backgroundColor behaves like the "Mac Pro" picture
                }
                
                if label.text == titles[min] {
                    var rgbValue = 0.5 - 0.5*(CGFloat(max)-mid)
                    if min == max { // Cause min cannot less than 0, do this to deal with the "max==min==mid==0"
                        rgbValue = 0
                    }
                    label.textColor = UIColor(red: rgbValue, green: rgbValue, blue: rgbValue, alpha: 1)
                }else if label.text == titles[max] {
                    let rgbValue = 0.5 - 0.5*(mid-CGFloat(min))
                    label.textColor = UIColor(red: rgbValue, green: rgbValue, blue: rgbValue, alpha: 1)
                }else{
                    label.textColor = UIColor.grayColor()
                }
            }
            
            // Indicator Change (position & length)
            let indicator = self.titleIndicator[0]
            
            for label:UILabel in self.titleLabels {
                if label.text == titles[index] {
                    UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                        indicator.frame = CGRectMake(
                            label.frame.origin.x, // same position with the selected label
                            indicator.frame.origin.y,
                            self.titlesWidth[index], // same length with the selected label
                            indicator.frame.height)
                        }, completion: nil)
                }
            }
            
            // Scroll
            if offset > width-30{ // Title almost beyond screen edge
                UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                    if self.scrollTitle.contentOffset.x < offset - width { // Let title scroll forward, not backward
                        self.scrollTitle.contentOffset.x = offset - width
                    }
                    }, completion: nil)
            }
            if offset < width {
                UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                    self.scrollTitle.contentOffset.x = 0
                    }, completion: nil)
            }
        }
    }
    
    
    // MARK: - Tap ScrollTitle
    func tapped0(){
        self.view.backgroundColor = UIColor.whiteColor() // ensure backgroundColor behaves like the "iPod" picture
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            self.scrollContent.contentOffset.x = (self.view.frame.width)*0
            }, completion: nil)
    }
    func tapped1(){
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            self.scrollContent.contentOffset.x = (self.view.frame.width)*1
            }, completion: nil)
    }
    func tapped2(){
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            self.scrollContent.contentOffset.x = (self.view.frame.width)*2
            }, completion: nil)
    }
    func tapped3(){
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            self.scrollContent.contentOffset.x = (self.view.frame.width)*3
            }, completion: nil)
    }
    func tapped4(){
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            self.scrollContent.contentOffset.x = (self.view.frame.width)*4
            }, completion: nil)
    }
    func tapped5(){
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            self.scrollContent.contentOffset.x = (self.view.frame.width)*5
            }, completion: nil)
    }
    func tapped6(){
        self.view.backgroundColor = UIColor.blackColor() // ensure backgroundColor behaves like the "Mac Pro" picture
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            self.scrollContent.contentOffset.x = (self.view.frame.width)*6
            }, completion: nil)
    }
    
    
    // MARK: - Hide Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

