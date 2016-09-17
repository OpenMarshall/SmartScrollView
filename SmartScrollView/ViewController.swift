//
//  ViewController.swift
//  SmartScrollView
//
//  Created by 徐开源 on 15/9/21.
//  Copyright © 2015年 徐开源. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    
    private let scrollTitleView = UIScrollView()
    private let scrollContentView = UIScrollView()
    private let labelTexts = ["iPod","iPad","iPhone","iMac","MacBook","Mac mini","Mac Pro"]
    private let labelWidths :[CGFloat] = [34,33,53,37,72,69,63]
    private var labels = [UILabel]()
    private var indicator = UIView() // label 下方的深蓝色横条
    
    private let selectedTextColor = UIColor.white
    private let unselectedTextColor = UIColor.lightGray
    private let lightBlueColor = UIColor(red:0.23, green:0.51, blue:0.85, alpha:1.00)
    private let darkBlueColor = UIColor(red:0.04, green:0.31, blue:0.62, alpha:1.00)
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 配置 ScrollView
        let scrollTitleHeight: CGFloat = 60
        scrollTitleView.frame = CGRect(x: 0, y: 0,
                                          width: view.frame.width, height: scrollTitleHeight)
        scrollContentView.frame = CGRect(x: 0, y: scrollTitleHeight,
                                          width: view.frame.width, height: view.frame.height-scrollTitleHeight)
        scrollTitleView.backgroundColor = lightBlueColor
        scrollContentView.isPagingEnabled = true
        scrollTitleView.showsHorizontalScrollIndicator = false
        scrollContentView.showsHorizontalScrollIndicator = false
        
        scrollTitleView.delegate = self
        scrollContentView.delegate = self
        
        view.addSubview(scrollTitleView)
        view.addSubview(scrollContentView)
        
        // 可滑动顶部标题
        let leftMargin: CGFloat = 15
        let topMargin: CGFloat = 30
        let horizontalInterval: CGFloat = 30
        let labelHeight: CGFloat = 20
        let indicatorHeight: CGFloat = 5
        var originX: CGFloat = 0
        
        for i in 0 ..< labelTexts.count {
            guard (labelTexts.count == labelWidths.count) else {continue}
            
            let label = UILabel(frame: CGRect(x: originX+leftMargin, y: topMargin,
                                              width: labelWidths[i], height: labelHeight))
            originX += horizontalInterval + labelWidths[i]
            label.text = labelTexts[i]
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.isUserInteractionEnabled = true
            label.textColor = unselectedTextColor
            if i == 0 {
                label.textColor = selectedTextColor
            }
            
            // Add Tap Gesture
            var sel = #selector(ViewController.lableTapped0)
            switch i {
            case 1:
                sel = #selector(ViewController.lableTapped1)
            case 2:
                sel = #selector(ViewController.lableTapped2)
            case 3:
                sel = #selector(ViewController.lableTapped3)
            case 4:
                sel = #selector(ViewController.lableTapped4)
            case 5:
                sel = #selector(ViewController.lableTapped5)
            case 6:
                sel = #selector(ViewController.lableTapped6)
            default:
                break
            }
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: sel))
            
            labels.append(label)
            scrollTitleView.addSubview(label)
        }
        
        indicator = UIView(frame: CGRect(x: leftMargin, y: topMargin+labelHeight+indicatorHeight,
                                             width: labelWidths[0], height: indicatorHeight))
        indicator.backgroundColor = darkBlueColor
        scrollTitleView.addSubview(indicator)
        scrollTitleView.contentSize = CGSize(width: originX, height: 0)
        
        // 可滑动内容
        originX = 0
        
        for i in 0 ..< labelTexts.count {
            let imageView = UIImageView(frame:
                CGRect(x: originX, y: 0, width: view.frame.width, height: view.frame.height-scrollTitleHeight))
            imageView.image = UIImage(named: labelTexts[i])
            imageView.contentMode = .scaleAspectFit
            switch labelTexts[i] {
            case "iPad":
                imageView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
            case "iPhone":
                imageView.backgroundColor = UIColor(red:0.07, green:0.07, blue:0.07, alpha:1.00)
            case "MacBook":
                imageView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
            case "Mac Pro":
                imageView.backgroundColor = UIColor.black
            default:
                imageView.backgroundColor = UIColor.white
            }
            originX += view.frame.width
            
            scrollContentView.addSubview(imageView)
        }
        scrollContentView.contentSize = CGSize(width: originX, height: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Detect Scroll ActionwithDuration
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard scrollView == scrollContentView else {return}
        
        let offsetX = scrollView.contentOffset.x
        let screenWidth = view.frame.width
        let horizontalInterval: CGFloat = 30
            
        let index:Int = Int( (offsetX + screenWidth/2)/screenWidth ) // Main Page Index When Scroll
        var min:Int = Int(ceil( offsetX/screenWidth )) - 1 // Left Page Index When Scroll
        var max:Int = min + 1 // Right Page Index When Scroll
        let mid:CGFloat = offsetX/screenWidth // Scroll Point
        
        // Label Color Change
        for label in labels {
            if min < 0 {
                min = 0
                view.backgroundColor = UIColor.white // iPod Image BgColor
            }
            if max >= labelTexts.count {
                max = labelTexts.count - 1
                view.backgroundColor = UIColor.black // Mac Pro Image BgColor
            }
            
            if label.text == labelTexts[min] {
                if min == max {
                    label.textColor = UIColor.white
                }else {
                    label.textColor = UIColor(white: 0.67 + 0.33*(CGFloat(max)-mid), alpha: 1.00)
                }
            }else if label.text == labelTexts[max] {
                label.textColor = UIColor(white: 0.67 + 0.33*(mid-CGFloat(min)), alpha: 1.00)
            }else {
                label.textColor = unselectedTextColor
            }
        }
        
        // Indicator Change (position & length)
        for label in labels {
            guard index < labelTexts.count else { continue }
            
            if label.text == labelTexts[index] {
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    self.indicator.frame = CGRect(
                        x: label.frame.origin.x, // same position with the selected label
                        y: self.indicator.frame.origin.y,
                        width: self.labelWidths[index], // same length with the selected label
                        height: self.indicator.frame.height)
                    }, completion: nil)
            }
        }
        
        // Scroll
        var selectedTitleCenterX:CGFloat = 15
        for i in 0...index {
            selectedTitleCenterX += labelWidths[i] + horizontalInterval
        }
        selectedTitleCenterX -= labelWidths[index]
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1, options: .allowAnimatedContent, animations: {
                        
                        let tempOffset = selectedTitleCenterX - screenWidth/2
                        let minOffset: CGFloat = 0
                        let maxOffset = self.scrollTitleView.contentSize.width - screenWidth
                        if tempOffset > maxOffset {
                            self.scrollTitleView.contentOffset.x = maxOffset
                        }else if tempOffset < minOffset {
                            self.scrollTitleView.contentOffset.x = minOffset
                        }else {
                            self.scrollTitleView.contentOffset.x = tempOffset
                        }
            }, completion: nil)
    }
    
    
    // MARK: - Tap ScrollTitle
    func lableTapped0() {
        view.backgroundColor = UIColor.white // iPod Image BgColor
        lableTapped(selectedLabelIndex: 0)
    }
    func lableTapped1() { lableTapped(selectedLabelIndex: 1) }
    func lableTapped2() { lableTapped(selectedLabelIndex: 2) }
    func lableTapped3() { lableTapped(selectedLabelIndex: 3) }
    func lableTapped4() { lableTapped(selectedLabelIndex: 4) }
    func lableTapped5() { lableTapped(selectedLabelIndex: 5) }
    func lableTapped6() {
        view.backgroundColor = UIColor.black // Mac Pro Image BgColor
        lableTapped(selectedLabelIndex: 6)
    }
    
    private func lableTapped(selectedLabelIndex:Int) {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.scrollContentView.contentOffset.x = (self.view.frame.width) * CGFloat(selectedLabelIndex)
            }, completion: nil)
    }
    
    
    // MARK: - Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

