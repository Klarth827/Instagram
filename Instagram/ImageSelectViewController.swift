//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by yuji on 2018/03/01.
//  Copyright © 2018年 yuji. All rights reserved.
//

import Foundation
import UIKit



class ImageSelectViewController: UIViewController ,UIImagePickerControllerDelegate , UINavigationControllerDelegate , AdobeUXImageEditorViewControllerDelegate {
    
    
    
    @IBAction func handleLibraryButton(_ sender: Any) {
        //ライブラリ　カメラロールを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func handleCameraButton(_ sender: Any) {
        
        //カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func handleCancelButton(_ sender: Any) {
        
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //写真を撮影・選択した時に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            
            //撮影選択された画像を取得する
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            //あとでAdobeエディターを起動する
            //AdobeUXImageEditorで、受け取ったimageを加工できる
            //ここでpresentViewControllerを呼び出しても表示されないためメソッドが終了してから呼び出す
            DispatchQueue.main.async{
                //adobeImageEditorを起動する
                let adobeViewController = AdobeUXImageEditorViewController(image: image)
                adobeViewController.delegate = self
                self.present(adobeViewController,animated: true, completion: nil)
            }
        }
        //閉じる
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    //AdobeImageEditorで加工が終わった時に呼ばれるメソッド
    func photoEditor(_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?){
        //画像加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
        
        //投稿の画面を開く
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image
        present(postViewController, animated: true, completion: nil)
        
    }
    
    //AdobeImageEditorで加工をキャンセルした時に呼ばれる
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController){
        //加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
        
    }
    
    //フォトライブラリやカメラ起動中にキャンセルした時に呼ばれるメソッド
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //閉じる
        picker.dismiss(animated:true, completion: nil)
    }
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
