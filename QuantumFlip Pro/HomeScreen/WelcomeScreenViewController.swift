//
//  WelcomeScreenViewController.swift
//  QuantumFlip slot
//
//  Created by Unique Consulting Firm on 14/02/2025.
//

import UIKit

class WelcomeScreenViewController: UIViewController {
    @IBOutlet weak var btngo: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //applyGradientToButton(button: btngo)

        // Do any additional setup after loading the view.
        let balance = UserDefaults.standard.integer(forKey: "CoinBalance")
           
           if balance <= 0
           {
               UserDefaults.standard.set(100, forKey: "CoinBalance")
               UserDefaults.standard.set(0, forKey: "BetAmount")
           }
           
       }
    
    

    @IBAction func Btnletgo(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    
    }

}
