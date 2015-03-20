//
//  OAuthViewController.swift
//  SwiftBlog
//
//  Created by King on 15/3/9.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    
    let WB_API_URL_String       = "https://api.weibo.com"
    let WB_Redirect_URL_String  = "http://www.baidu.com"
    let WB_Client_ID            = "4266907357"
    let WB_Client_Secret        = "a3954639f9a74db9d7d2861f4fb94fda"
    let WB_Grant_Type           = "authorization_code"
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAuthPage()
    }
    
    /// 加载授权页面
    func loadAuthPage() {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_Client_ID)&redirect_uri=\(WB_Redirect_URL_String)"
        let url = NSURL(string: urlString)
        
        webView.loadRequest(NSURLRequest(URL: url!))
    }
}

extension OAuthViewController: UIWebViewDelegate {
    
    /// 页面重定向
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        println(request.URL)
        
        let result = continueWithCode(request.URL!)
        
        if let code = result.code {
            println("可以换 accesstoke \(code)")
            
            let params = ["client_id": WB_Client_ID,
                "client_secret": WB_Client_Secret,
                "grant_type": WB_Grant_Type,
                "redirect_uri": WB_Redirect_URL_String,
                "code": code]

            let net = NetWorkManager.sharedManager
            net.requestJSON(.POST, "https://api.weibo.com/oauth2/access_token", params, completion: { (result, error) -> () in
                
                let token = AccessToken(dict: result as! NSDictionary)
                token.saveAccessToken()
            })
        }
        if !result.load {
            if result.reloadPage {
                SVProgressHUD.showInfoWithStatus("你真的残忍的拒绝吗？", maskType: SVProgressHUDMaskType.Gradient)
                loadAuthPage()
            }
        }
        
        return result.load
    }
    
    ////  根据URL判断是否继续
    ///
    ///  :param: url URL
    ///
    ///  :returns: 1. 是否加载当前页面 2. code(如果有) 3. 是否刷新授权页面
    func continueWithCode(url: NSURL) -> (load: Bool, code: String?, reloadPage: Bool) {
        
        let urlString = url.absoluteString!
        
        if !urlString.hasPrefix(WB_API_URL_String) {
            if urlString.hasPrefix(WB_Redirect_URL_String) {
                if let query = url.query {
                    let codestr: NSString = "code="
                    
                    // 访问新浪微博授权的时候，带有回调地址的url只有两个，一个是正确的，一个是错误的！
                    if query.hasPrefix(codestr as String) {
                        var q = query as NSString!
                        return (false, q.substringFromIndex(codestr.length), false)
                    } else {
                        return (false, nil, true)
                    }
                }
            }
            
            return (false, nil, false)
        }
        
        return (true, nil, false)
    }
}
