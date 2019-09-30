//
//  LNShare2ViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/12/2.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNShare2ViewController: LNBaseViewController {

    @objc var shareImage : [String]?
    @objc var shareImages : [UIImage]?
    @objc var typeString : String?
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var bg_view: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.6)
        button1.layoutButton(with: .top, imageTitleSpace: 10)
        button2.layoutButton(with: .top, imageTitleSpace: 10)
        button3.layoutButton(with: .top, imageTitleSpace: 10)
        navigaView.isHidden = true
    }

    @IBAction func chooseSharePalatm(_ sender: UIButton) {
        if typeString == "2" {
            weak var weakSelf = self
            DispatchQueue.main.async {
                switch sender.tag {
                case 102:
                    let activityVC = UIActivityViewController.init(activityItems: (weakSelf?.shareImages)!, applicationActivities: nil)
                    self.presentingViewController!.present(activityVC, animated: true, completion: nil)
                case 103:
                    let activityVC = UIActivityViewController.init(activityItems: (weakSelf?.shareImages)!, applicationActivities: nil)
                    self.presentingViewController!.present(activityVC, animated: true, completion: nil)
                case 101:
                    for url in (weakSelf?.shareImages)! {
                        UIImageWriteToSavedPhotosAlbum(url, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
                    }
                    return
                default:
                    break
                }
            }
        } else {
            DispatchQueue.main.async {
                var images = [UIImage]()
                for url in self.shareImage! {
                    if url.contains("http") {
                        let data = try! Data.init(contentsOf: URL.init(string: url)!)
                        let image = UIImage.init(data: data as Data)
                        images.append(image!)
                    }
                }
                switch sender.tag {
                case 102:
                    let activityItems = images
                    let activityVC = UIActivityViewController.init(activityItems: activityItems, applicationActivities: nil)
                    self.presentingViewController!.present(activityVC, animated: true, completion: nil)
                case 103:
                    let activityItems = images
                    let activityVC = UIActivityViewController.init(activityItems: activityItems, applicationActivities: nil)
                    self.presentingViewController!.present(activityVC, animated: true, completion: nil)
                case 101:
                    DispatchQueue.main.async(execute: { () -> Void in
                        LQLoadingView().SVPWillShow("保存中")
                        //                    setToast(str: "保存中")
                    })
                    DispatchQueue.init(label: "saveImages").async(execute: {
                        for url in self.shareImage! {
                            if url.contains("http") {
                                let data = try! Data.init(contentsOf: URL.init(string: url)!)
                                let image = UIImage.init(data: data as Data)
                                UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
                            }
                        }
                    })
                    return
                default:
                    break
                }
            }
        }
        self.dismiss(animated: false, completion: nil)
    }
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if typeString == "2" {
            LQLoadingView().SVPwillSuccessShowAndHide("图片已保存")
        } else {
            DispatchQueue.init(label: "saveImages").async(execute: {
                LQLoadingView().SVPwillSuccessShowAndHide("图片已保存")
            })
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: false, completion: nil)
    }
}
