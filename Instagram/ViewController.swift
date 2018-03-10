//
//  ViewController.swift
//  Instagram
//
//  Created by yuji on 2018/03/01.
//  Copyright © 2018年 yuji. All rights reserved.
//

import UIKit
import ESTabBarController

import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupTab()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTab(){
        
        //画像のファイル名を指定してESTabBarControllerを作成する
        
        let tabBarController:ESTabBarController! = ESTabBarController(tabIconNames: ["home","camera","setting"])
        
        //背景色、選択時の色を設定する
        
        tabBarController.selectedColor = UIColor(red: 1.0, green:0.44, blue:0.11, alpha: 1)
        
        //作成したESTabBarControllerを親のViewController（=self)に追加する
        
        addChildViewController(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.view.frame = view.bounds
        tabBarController.didMove(toParentViewController: self)
        
        //タブをタップした時に表示するViewControllerを設定する
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        
        tabBarController.setView(homeViewController, at:0)
        tabBarController.setView(settingViewController, at:2)
        
        //真ん中のタブはボタンとして扱う
        
        tabBarController.highlightButton(at: 1)
        tabBarController.setAction({
            //ボタンが押されたらImageViewControllerをモーダルで表示する
            let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect")
            self.present(imageViewController!, animated: true, completion: nil)
            
        }, at: 1)
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        //currentUserがnilならログインしてない
        if Auth.auth().currentUser == nil {
            //ログインしていない時の処理
            //viewDidAppear 内でpresent()を呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                
                self.present(loginViewController!, animated: true, completion: nil)
                
            }
        }
    }
    
}

