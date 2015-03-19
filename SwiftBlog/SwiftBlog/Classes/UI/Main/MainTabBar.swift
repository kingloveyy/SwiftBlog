//
//  MainTabBar.swift
//  SwiftBlog
//
//  Created by King on 15/3/19.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class MainTabBar: UITabBar {
    
    /// 定义撰写微博按钮回调
    var composeButtonClicked: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(composeBtn!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setButtonFrame()
    }
    
    ///  设置按钮位子
    func setButtonFrame() {
        
        let buttonCount = 5
        let w = self.bounds.size.width / CGFloat(buttonCount)
        let h = self.bounds.size.height
        
        var index = 0
        for view in self.subviews as! [UIView] {
            if view is UIControl && !(view is UIButton) {
                let frame = CGRectMake(w * CGFloat(index), 0, w, h)
                view.frame = frame
                index++
            }
            
            if index == 2 {
                index++
            }
        }
        
        composeBtn?.frame = CGRectMake(0, 0, w, h)
        composeBtn?.center = CGPointMake(self.center.x, h * 0.5)
    }
    
    lazy var composeBtn: UIButton? = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        btn.addTarget(self, action: "composeClick", forControlEvents: .TouchUpInside)
        return btn
        }()
    
    func composeClick() {
        if composeButtonClicked != nil {
            composeButtonClicked!()
        }
    }

}
