//
//  TrashAnimationVC.swift
//  Trashy
//
//  Created by Kai Zheng on 4/26/19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit
import Hero

class TrashAnimationVC: UIViewController {
    
    var produktArray = [Produkt]()
    var trashNumber = 0
    
    @IBOutlet weak var trashAnimationView: UIView!
    @IBOutlet weak var trashAnimationImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //trashAnimationView.backgroundColor = UIColor(named: color)
        
        self.hero.isEnabled = true
        trashAnimationImageView.hero.id = "trashAnimation"
        trashAnimationView.hero.modifiers = [.translate(x: -120)]
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        
        self.trashAnimationView.transform = self.trashAnimationView.transform.rotated(by: CGFloat(0.349066))
        //self.muelleimerDeckelView.frame.origin.x += 3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.4, animations: {
                self.trashAnimationImageView.frame.origin.y += 10
                //self.muelleimerDeckelView.frame.origin.x -= 3
                self.trashAnimationView.transform = self.trashAnimationView.transform.rotated(by: CGFloat(-0.349066))
            }, completion: { (finished: Bool) in
                UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
                    self.trashAnimationView.frame.origin.y -= 5
                }, completion: { (finished: Bool) in
                    UIView.animate(withDuration: 0.4, delay: 0.0, animations: {
                        //deckel schließen
                        self.trashAnimationView.frame.origin.y += 35
                        //self.muelleimerDeckelView.frame.origin.x += 3
                        self.trashAnimationView.transform = CGAffineTransform(scaleX: 1.0, y: 1.2)
                        
                        //self.muelleimerDeckelView.frame.origin.x += 15
                        
                        //self.muelleimerDeckelView.transform = self.muelleimerDeckelView.transform.rotated(by: CGFloat(0.349066))
                    /*}, completion: { (finished: Bool) in
                        UIView.animate(withDuration: 0.3, animations: {
                            self.muelleimerImageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                            self.muelleimerDeckelView.transform = CGAffineTransform(scaleX: 2, y: 2)
                            self.muelleimerImageView.alpha = 0.0
                            self.muelleimerDeckelView.alpha = 0.0
                        }, completion: { (finished: Bool) in
                        })*/
                    }, completion: { (finished: Bool) in
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let ergebnisVC = storyBoard.instantiateViewController(withIdentifier: "ErgebnisVCSB") as! ErgebnisVC
                        
                        ergebnisVC.produktArray = self.produktArray
                        ergebnisVC.trashNumber = self.trashNumber
                        
                        self.present(ergebnisVC, animated: true, completion: nil)
                    })
                })
            })
        }
    }
}
