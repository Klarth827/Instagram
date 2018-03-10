//
//  HomeViewController.swift
//  Instagram
//
//  Created by yuji on 2018/03/01.
//  Copyright © 2018年 yuji. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class HomeViewController : UIViewController, UITableViewDataSource,  UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray:[PostData] = []
    
    //databaseのobserveEventの登録状態を表す
    
    var observing = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //テーブルセルのタップを無効にする
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register (nib, forCellReuseIdentifier:"Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated : Bool){
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                //要素が追加されたらpostArrayに追加してTableviewを再表示する
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.observe(.childAdded, with: {snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました")
                    
                    //PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot : snapshot, myId: uid)
                        self.postArray.insert(postData, at: 0)
                        
                        //TableViewを再表示する
                        self.tableView.reloadData()
                        
                    }})
                //要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                
                postsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childCangedイベントが発生しました。")
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        
                        //postDataクラスを生成して受け取ったデータを設定する
                        let postData = PostData(snapshot : snapshot, myId: uid)
                        
                        //保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postData.id {
                                index = self.postArray.index(of: post)!
                                break
                            }
                        }
                        
                        //差し替えるため一度削除する
                        self.postArray.remove(at: index)
                        
                        //削除したところにデータを追加する
                        self.postArray.insert(postData, at: index)
                        
                        //tableviewの現在表示されているセルを更新する
                        self.tableView.reloadData()
                    }})
                
                //DatabaseのobserveEventが上記コードにより登録されたため
                //trueにする
                
                observing = true
            }
        }
        else {
            if observing == true {
                //ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する
                //テーブルをクリアする
                postArray = []
                tableView.reloadData()
                //オブザーバーを削除する
                Database.database().reference().removeAllObservers()
                
                //DatabaseのobserveEbentが上記コードにより解除されたため
                //falseとする
                observing = false
            }
        }
    }
    
    func tableView(_ tabaleView : UITableView, numberOfRowsInSection section : Int)->Int {
        return postArray.count
    }
    
    func tableView(_ tabaleView : UITableView, cellForRowAt indexPath : IndexPath)->UITableViewCell {
        
        //せるを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! PostTableViewCell
        cell.setPostData(postData:postArray[indexPath.row])
        
        //せるないのボタンアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action: #selector(handleButton(sender: event:)), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    
    
    func tableView(_ tableView : UITableView, estimatedHeightForRowAt indexPath : IndexPath)->CGFloat {
        
        //AutoLayoutを使ってせるのたかさを動的に変更する
        return UITableViewAutomaticDimension
    }
    
    
    
    func tableView(_ tableView : UITableView, didSelectRowAt indexPath : IndexPath) {
        //せるをタップされたら何もせずに選択状態を解除する。
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
    
    //セル内のボタンがタップされた時に呼ばれるメソッド
    func handleButton(sender : UIButton, event : UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました")
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in : self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスのデータを取り出す
        
        let postData = postArray[indexPath!.row]
        
        //firebase に　保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            
            if postData.isLiked {
                
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in postData.likes {
                    
                    if likeId == uid {
                        
                        //削除するためにインデックスを保存しておく
                        
                        index = postData.likes.index(of : likeId)!
                        break
                    }
                    
                }
                
                postData.likes.remove(at: index)
                
            }else{
                
                postData.likes.append(uid)
            }
            
            
            //増えたlikesをFirebase に保存する
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
            
        }
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
