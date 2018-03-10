//
//  SettingViewController.swift
//  Instagram
//
//  Created by yuji on 2018/03/01.
//  Copyright © 2018年 yuji. All rights reserved.
//

import Foundation
import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD


class SettingViewController: UIViewController {
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    
    @IBAction func handleCangeButton(_ sender: Any) {
        
        if let displayName = displayNameTextField.text{
            
            //表示名が入力されていない時はHUDを出して何もしない
            if displayName.characters.isEmpty{
                SVProgressHUD.showError(withStatus: "表示名を入力してくださ")
                return
            }
            
            //表示名を設定する
            let user = Auth.auth().currentUser
            
            if let user = user {
                
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("DEBUG_PRINT: " + error.localizedDescription)
                    }
                    print("DEBUG_PRINT: [displayName = \(String(describing: user.displayName))]の設定に成功しました")
                    
                    //HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                    
                }
                
            } else {
                print("DEBUG_PRINT: displayNameの設定に失敗しました。")
            }
        }
        //キーボードを閉じる
        self.view.endEditing(true)
    }
    
    @IBAction func handleLogoutButton(_ sender: Any) {
        
        //ログアウトボタンをタップした時に呼ばれるメソッド
        
    //ログアウトする
        try! Auth.auth().signOut()
        
        //ログイン画面を表示する
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")

        self.present(loginViewController!, animated: true, completion: nil)
        
        //ログイン画面から戻ってきた時のためにホーム画面(index = 0 )を選択している状態にしておく
        
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        //表示名を取得してTextFieldに設定する
        
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
    }
    
}
