//
//  ViewController.swift
//  ka-dosuwaipuApp
//
//  Created by 津國　由莉子 on 2019/08/10.
//  Copyright © 2019 yurityann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var baseCard: UIView!
    
    
    @IBOutlet weak var likeImage: UIImageView!
    
    //ユーザーカード
    @IBOutlet weak var person1: UIView!
    
    @IBOutlet weak var person2: UIView!
    
    @IBOutlet weak var person3: UIView!
    
    @IBOutlet weak var person4: UIView!
    
    @IBOutlet weak var person5: UIView!
    
    //ベースカードの座標管理
    var centerOFCard: CGPoint!
    
    //ユーザーカードの配列
    var personList: [UIView] = []
    //選択されたカードの数
    var selectedCardCount: Int = 0
    //ユーザーリスト
    let nameList: [String] = ["津田梅子","ジョージワシントン","ガリレオガリレイ","板垣退助","ジョン万次郎"]
    //
    var likedName: [String] = []
    
    
    override func viewDidLayoutSubviews() {
        //ベースカードの中心代入
        centerOFCard = baseCard.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // personListにperson1から5を追加
        personList.append(person1)
        personList.append(person2)
        personList.append(person3)
        personList.append(person4)
        personList.append(person5)
        
    }
    
    // viewが表示される直前に呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // カウント初期化
        selectedCardCount = 0
        // リスト初期化
        likedName = []
    }
    
    // 完全に遷移が行われ、スクリーン上からViewControllerが表示されなくなったときに呼ばれる
    override func viewDidDisappear(_ animated: Bool) {
        // ユーザーカードを元に戻す
        resetPersonList()
    }
    
    
    //遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToLikedList"{
            let vc = segue.destination as! LikedListTableViewController
            // LikedListTableViewControllerのlikedName(左)にViewCountrollewのLikedName(右)を代入
            vc.likedName = likedName
        }
    }
    
    //
    func resetPersonList() {
        // 5人の飛んで行ったビューを元の位置に戻す
        for person in personList {
            // 元に戻す処理
            person.center = self.centerOFCard
            person.transform = .identity
        }
    }
    
    //ベースカードを元に戻す
    func resetCard() {
        //位置を戻す
        baseCard.center = centerOFCard
        //角度を戻す
        baseCard.transform = .identity
    }
    
    
    
    @IBAction func swipeCared(_ sender: UIPanGestureRecognizer) {
        
        //こののカードは透明のカードのこと
        let card = sender.view!
        
        //動いた距離
        let point = sender.translation(in: view)
        
        // 取得できた距離をcard.centerに加算
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        
        // ユーザーカードにも同じ動きをさせる
        personList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        
        // 元々の位置と移動先との差
        let xfromCenter = card.center.x - view.center.x
        
        //角度をつける処理（ベースカード）
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        //角度をつける処理（ユーザーカード）
        personList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        
        if xfromCenter > 0 {
            //goodイメージ表示
            likeImage.image = #imageLiteral(resourceName: "いいね")
            likeImage.isHidden = false
            
        } else if xfromCenter < 0 {
            //badイメージ表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
        }
        
        
        
        
        //元の位置に戻す処理
        if sender.state == UIGestureRecognizer.State.ended{
            // 指を離した場合の処理
            if sender.state == UIGestureRecognizer.State.ended {
                // 離した時点のカードの中心の位置が左から50以内のとき
                if card.center.x < 50 {
                    // 左に大きくスワイプしたときの処理
                    UIView.animate(withDuration: 0.5, animations: {
                        
                        // 該当のユーザーカードを画面外(マイナス方向)へ飛ばす
                        self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x - 500, y: self.personList[self.selectedCardCount].center.y)
                    })
                    //ベースカードの角度と位置を戻す
                    resetCard()
                    //likeimageを隠す
                    likeImage.isHidden = true
                    //次のカードへ
                    selectedCardCount += 1
                    //遷移（５になった瞬間だからselectedCardCount += 1のすぐ後）
                    if selectedCardCount >= personList.count {
                        performSegue(withIdentifier: "ToLikedList", sender: self)
                    }
                    
                    
                    
                    // 離した時点のカードの中心の位置が右から50以内のとき
                } else if card.center.x > self.view.frame.width - 50 {
                    // 右に大きくスワイプしたときの処理
                    UIView.animate(withDuration: 0.5, animations: {
                        
                        
                        // 該当のユーザーカードを画面外(プラス方向)へ飛ばす
                        self.personList[self.selectedCardCount].center = CGPoint(x:self.personList[self.selectedCardCount].center.x + 500, y: self.personList[self.selectedCardCount].center.y)
                    })
                    //ベースカードの角度と位置を戻す
                    resetCard()
                    //likeimageを隠す
                    likeImage.isHidden = true
                    //いいねリストに追加
                    likedName.append(nameList[selectedCardCount])
                    //次のカードへ
                    selectedCardCount += 1
                    //遷移（５になった瞬間だからselectedCardCount += 1のすぐ後）
                    if selectedCardCount >= personList.count {
                        performSegue(withIdentifier: "ToLikedList", sender: self)
                    }
                    // それ以外は元の位置に戻す
                } else {
                    UIView.animate(withDuration: 0.5, animations: {
                        
                        // ユーザーカードを元の位置に戻す
                        self.personList[self.selectedCardCount].center = self.centerOFCard
                        
                        
                        // ユーザーカードの角度を元の位置に戻す
                        self.personList[self.selectedCardCount].transform = .identity
                        //ベースカードの角度と位置を戻す
                        self.resetCard()
                        self.likeImage.isHidden = true
                        
                    })
                }
                
                
                
            }
            
            //            if card.center.x < 50 {
            //              //左に大きく諏訪イプした時の処理
            //                UIView.animate(withDuration: 2, animations: {
            //
            //                // 左へ飛ばす場合
            //                // X座標を左に500とばす(-500)
            //                    self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x - 500, y :self.personList[self.selectedCardCount].center.y)
            //                })
            //
            //                baseCard.center = centerOFCard
            //
            //            } else if card.center.x > self.view.frame.width - 50 {
            //                UIView.animate(withDuration: 2, animations:{
            //
            //                // 右へ飛ばす場合
            //                // X座標を右に500とばす(+500)
            //                    self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + 500, y :self.personList[self.selectedCardCount].center.y)
            //                })
            //
            //
            //                baseCard.center = centerOFCard
            //
            //            }
            //
            //        } else {
            //            //アニメーションつける
            //         UIView.animate(withDuration: 0.5, animations: {
            //
            //                // ベースカードを元の位置に戻す
            //                self.baseCard.center = self.centerOFCard
            //                // ユーザーカードを元の位置に戻す
            //                self.personList[self.selectedCardCount].center = self.centerOFCard
            //            })
            //
            //        }
            //
        }
        
    }
    
    
    @IBAction func dislikebuttontapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.resetCard()
            
            self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x - 500,
                                                                     y:self.personList[self.selectedCardCount].center.y)
        })
        selectedCardCount += 1
        
        if selectedCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }
    
    @IBAction func likebuttontapped(_ sender: Any) {
        print(selectedCardCount)
        UIView.animate(withDuration: 0.5, animations: {
            self.resetCard()
            
            self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + 500, y:self.personList[self.selectedCardCount].center.y)
        })
        
        likedName.append(nameList[selectedCardCount])
        selectedCardCount += 1
        
        if selectedCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
    }
    
    
    
}

