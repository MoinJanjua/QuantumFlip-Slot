//
//  DashboardViewController.swift
//  QuantumFlip slot
//
//  Created by Unique Consulting Firm on 14/02/2025.
//

import UIKit

class DashboardViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var MainView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let imagesList = ["img1","img2","img3","img4",]
    let titleList =  [
        "Spin & Win",
        "Scoreboard",
        "Flips History",
        "App Setting",
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        // Register the custom cell
       // applyCornerRadiusToBottomCorners(view: MainView, cornerRadius: 25)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DashboardCollectionViewCell
        
        cell.titleImage.image = UIImage(named: imagesList[indexPath.row])
        cell.titleLb.text = titleList[indexPath.row]
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.systemRed.cgColor
        cell.contentView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacing: CGFloat = 10
        let availableWidth = collectionViewWidth - (spacing * 2)
        let width = availableWidth / 2
        return CGSize(width: width - 20, height: width + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "PlayandflipViewController") as! PlayandflipViewController
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }
                
              
           else if indexPath.row == 1
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ScoresViewController") as! ScoresViewController
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }
        
        else if indexPath.row == 2
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }

        
                else if indexPath.row == 3
                {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                    newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    newViewController.modalTransitionStyle = .crossDissolve
                    self.present(newViewController, animated: true, completion: nil)
                }
        
        //        else if indexPath.row == 5
        //        {
        //            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ShowDoctorCheckupViewController") as! ShowDoctorCheckupViewController
        //            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //            newViewController.modalTransitionStyle = .crossDissolve
        //            self.present(newViewController, animated: true, completion: nil)
        //        }
        //        else if indexPath.row == 6
        //        {
        //            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddVaccinationViewController") as! AddVaccinationViewController
        //            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //            newViewController.modalTransitionStyle = .crossDissolve
        //            self.present(newViewController, animated: true, completion: nil)
        //        }
        //
        //        else if indexPath.row == 7
        //        {
        //            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ShowVaccinationViewController") as! ShowVaccinationViewController
        //            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //            newViewController.modalTransitionStyle = .crossDissolve
        //            self.present(newViewController, animated: true, completion: nil)
        //        }
        //        else if indexPath.row == 8
        //        {
        //            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        //            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //            newViewController.modalTransitionStyle = .crossDissolve
        //            self.present(newViewController, animated: true, completion: nil)
        //        }
        //
        //  }
    }
}
