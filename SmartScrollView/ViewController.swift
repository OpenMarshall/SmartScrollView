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
    
    private let animationDuration: TimeInterval = 0.8
    private let animationDamping: CGFloat = 0.7
    private let animationSpringVelocity: CGFloat = 1
    
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
        let labelHeight: CGFloat = 20
        let indicatorHeight: CGFloat = 5
        var originX: CGFloat = 0
        
        for i in 0 ..< labelTexts.count {
            guard (labelTexts.count == labelWidths.count) else {break}
            
            let label = UILabel(frame: CGRect(x: originX+leftMargin, y: topMargin,
                                              width: labelWidths[i], height: labelHeight))
            originX += 30 + labelWidths[i]
            label.text = labelTexts[i]
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.isUserInteractionEnabled = true
            label.textColor = unselectedTextColor
            if i == 0 {
                label.textColor = selectedTextColor
            }
            
            // 点击事件
            var sel = #selector(ViewController.lableTapped0)
            switch i {
            case 1:
                sel = #selector(ViewController.lableTapped1)
                break
            case 2:
                sel = #selector(ViewController.lableTapped2)
                break
            case 3:
                sel = #selector(ViewController.lableTapped3)
                break
            case 4:
                sel = #selector(ViewController.lableTapped4)
                break
            case 5:
                sel = #selector(ViewController.lableTapped5)
                break
            case 6:
                sel = #selector(ViewController.lableTapped6)
                break
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
            let imageName = labelTexts[i]
            imageView.image = UIImage(named:imageName)
            imageView.contentMode = .scaleAspectFit
            switch imageName {
            case "iPad":
                imageView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
                break
            case "iPhone":
                imageView.backgroundColor = UIColor(red:0.07, green:0.07, blue:0.07, alpha:1.00)
                break
            case "MacBook":
                imageView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
                break
            case "Mac Pro":
                imageView.backgroundColor = UIColor.black
                break
            default:
                imageView.backgroundColor = UIColor.white
                break
            }
            originX += view.frame.width
            
            scrollContentView.addSubview(imageView)
        }
        scrollContentView.contentSize = CGSize(width: originX, height: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - 监测内容滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard scrollView == scrollContentView else {return}
        
        let offsetX = scrollView.contentOffset.x
        let screenWidth = view.frame.width
            
        let index = Int( (offsetX + screenWidth/2)/screenWidth ) // Current Page Index When Scroll
        var min = Int(ceil( offsetX/screenWidth )) - 1 // Left Page Index When Scroll
        var max = min + 1 // Right Page Index When Scroll
        let mid:CGFloat = offsetX/screenWidth // Scroll Point
        
        // 改变标题 Label 颜色
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
        
        // 改变 indicator 横条的位置和长度
        for label in labels {
            guard index < labelTexts.count else { continue }
            
            if label.text == labelTexts[index] {
                UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: animationDamping,
                               initialSpringVelocity: animationSpringVelocity, options: .allowAnimatedContent, animations: {
                    self.indicator.frame = CGRect(
                        x: label.frame.origin.x, // same position with the selected label
                        y: self.indicator.frame.origin.y,
                        width: self.labelWidths[index], // same length with the selected label
                        height: self.indicator.frame.height)
                    }, completion: nil)
            }
        }
        
        // 内容滚动带动标题滚动
        var selectedTitleCenterX: CGFloat = 15
        for i in 0...index {
            selectedTitleCenterX += labelWidths[i] + 30
        }
        selectedTitleCenterX -= labelWidths[index]
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: animationDamping,
                       initialSpringVelocity: animationSpringVelocity, options: .allowAnimatedContent, animations: {
                        
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
    
    
    // MARK: - 滑动标题点击事件
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
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: animationDamping,
                       initialSpringVelocity: animationSpringVelocity, options: .allowAnimatedContent, animations: {
            self.scrollContentView.contentOffset.x = (self.view.frame.width) * CGFloat(selectedLabelIndex)
            }, completion: nil)
    }
    
    
    // MARK: - Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

