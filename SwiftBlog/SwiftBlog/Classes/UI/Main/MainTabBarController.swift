//
//  MainTabBarController.swift
//  SwiftBlog
//
//  Created by King on 15/3/19.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    
    @IBOutlet weak var mainTabBar: MainTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addControllers()
        
        weak var weakSelf = self
        mainTabBar.composeButtonClicked = {
            let sb = UIStoryboard(name: "Compose", bundle: nil)
            weakSelf!.presentViewController(sb.instantiateInitialViewController() as! UIViewController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///  添加子控制器
    func addControllers() {
        addChildControllers("Home", "首页", "tabbar_home", "tabbar_home_highlighted")
        addChildControllers("Message", "消息", "tabbar_message_center", "tabbar_message_center_highlighted")
        addChildControllers("Discover", "发现", "tabbar_discover", "tabbar_discover_highlighted")
        addChildControllers("Profile", "我", "tabbar_profile", "tabbar_profile_highlighted")
    }
    
    ///  添加视图控制器
    ///
    ///  :param: name      storyboard 名字
    ///  :param: title     标题
    ///  :param: imageName 图片名称
    ///  :param: highlight 高亮图片名称
    func addChildControllers(name: String, _ title: String, _ imageName: String, _ highlight: String) {
        let sb = UIStoryboard(name: name, bundle: nil)
        let vc = sb.instantiateInitialViewController() as! UINavigationController
        
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: highlight)?.imageWithRenderingMode(.AlwaysOriginal)
        vc.tabBarItem.title = title
        
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orangeColor()], forState: UIControlState.Selected)
        
        self.addChildViewController(vc)
    }
}
