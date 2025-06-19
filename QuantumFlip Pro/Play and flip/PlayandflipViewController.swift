//
//  PlayandflipViewController.swift
//  QuantumFlip slot
//
//  Created by Unique Consulting Firm on 14/02/2025.
//

import UIKit

class PlayandflipViewController: UIViewController {
    
    // MARK: - Data
    private let symbols = ["⚽️","🎯", "🍓",  "🌟", "🎈" ]
    private var timer: Timer?
    private var coinBalance: Int {
        
//
        get {
            return UserDefaults.standard.integer(forKey: "CoinBalance")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CoinBalance")
        }
    }
    private var betAmount: Int {
        get {
            return UserDefaults.standard.integer(forKey: "BetAmount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "BetAmount")
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var reelsStackView: UIStackView!
    @IBOutlet weak var spinButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var viewcoinsLabel: UILabel!
    @IBOutlet weak var betAmountTextField: UITextField!
    @IBOutlet weak var betView: UIView!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var handleImage: UIImageView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupReelsSafely()
        updateCoinsLabel()
        betAmountTextField.text = "\(betAmount)"
        if betAmount > 0
        {
            betView.isHidden = true
        }
        viewcoinsLabel.text = coinsLabel.text
        
        let jeremyGif = UIImage.gifImageWithName("coins")
        coinImage.image = jeremyGif
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    
    func shakeHandle() {
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.values = [-5, 5, -5, 5, -2, 2, 0]
        shake.duration = 0.3
        handleImage.layer.add(shake, forKey: "shake")
    }

    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        betView.resignFirstResponder()
    }

    // MARK: - Setup Reels
    private func setupReelsSafely() {
        guard reelsStackView != nil else {
            print("reelsStackView is nil!")
            return
        }
        for label in reelsStackView.arrangedSubviews {
            if let reelLabel = label as? UILabel {
                reelLabel.text = symbols.randomElement()
            }
        }
    }
    
    private func updateCoinsLabel() {
        coinsLabel.text = "\(coinBalance)"
        viewcoinsLabel.text = coinsLabel.text
    }
    
    // MARK: - Actions
    
    @IBAction func addBetAmount(_ sender: UIButton) {
        guard let bet = Int(betAmountTextField.text ?? "0"), bet > 0, bet <= coinBalance else {
           // resultLabel.text = "Invalid Bet Amount!"
            showAlert(title: "Invalid Bet Amount", message: "Please enter an amount that is within your current coin balance.")
            return
        }
        betView.isHidden = true
        betAmount = bet
    }
    
    @IBAction func didTapSpin(_ sender: UIButton) {
        
        
        guard let bet = Int(betAmountTextField.text ?? "0"), bet > 0, bet <= coinBalance else {
            
            betView.isHidden = false
            resultLabel.text = "Invalid Bet Amount!"
            return
        }
        shakeHandle()
        coinBalance -= bet
        updateCoinsLabel()
        
        spinButton.isEnabled = false
        resultLabel.text = "Spinning..."
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateReels()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.timer?.invalidate()
            self?.timer = nil
            self?.checkResult()
            self?.spinButton.isEnabled = true
        }
    }
    
    private func updateReels() {
        for label in reelsStackView.arrangedSubviews {
            if let reelLabel = label as? UILabel {
                reelLabel.text = symbols.randomElement()
            }
        }
    }
    private func checkResult() {
        let middleSymbols = reelsStackView.arrangedSubviews.compactMap { ($0 as? UILabel)?.text }
        
        // Check for a perfect match (all three symbols are the same)
        if Set(middleSymbols).count == 1 {
            let reward = betAmount * 5 // Example: 5x reward multiplier
            coinBalance += reward
            resultLabel.text = "🎉 JACKPOT! You matched all three symbols and won \(reward) coins! 🎉"
            
            // Save the score when jackpot occurs
            saveScore(score: reward)
            
            // Navigate to AddScoresViewController and pass the score
            navigateToAddScoresViewController(withScore: reward)
        }
        // Check for two matching symbols
        else if middleSymbols[0] == middleSymbols[1] || middleSymbols[1] == middleSymbols[2] || middleSymbols[0] == middleSymbols[2] {
            let partialReward = 10 // Example: 10 coins for two matches
            coinBalance += partialReward
            resultLabel.text = "🎉 You matched two symbols and earned \(partialReward) coins!"
        }
        // No match
        else {
            let loss = betAmount / 2 // Example: Lose half the bet amount
            coinBalance -= loss
            resultLabel.text = "No match. You lost \(loss) coins. Try again!"
        }
        
        // Update coins label
        updateCoinsLabel()
        
        // Check if the user is out of coins
        if coinBalance <= 0 {
            resultLabel.text = "You're out of coins! Please restart the game."
            showAlertAndRestart()
            coinBalance = 0
            coinsLabel.text = "\(coinBalance)"
            viewcoinsLabel.text = coinsLabel.text
        }
    }

    // Function to navigate to AddScoresViewController and pass the score
    private func navigateToAddScoresViewController(withScore score: Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let addScoresVC = storyBoard.instantiateViewController(withIdentifier: "AddScoresViewController") as? AddScoresViewController {
            addScoresVC.score = "\(score)"  // Pass the score to the next screen
            addScoresVC.modalPresentationStyle = .fullScreen
            addScoresVC.modalTransitionStyle = .crossDissolve
            present(addScoresVC, animated: true, completion: nil)
        }
    }



    private func saveScore(score: Int) {
        
        guard score > 0 else { return }
        
       
        UserDefaults.standard.set(score, forKey: "SavedScore")
    
    }
    private func showAlertAndRestart() {
        // Only allow saving score if balance is greater than 0
        guard coinBalance > 0 else {
                // Show alert to notify the user that they cannot save a score with a balance of zero or less
                let alert = UIAlertController(
                    title: "Error",
                    message: "Cannot save score with a balance of zero or less.",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "Go to Home Screen", style: .default, handler: { _ in
                    // Navigate to the home screen (DashboardViewController)
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    if let newViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
                        newViewController.modalPresentationStyle = .fullScreen
                        newViewController.modalTransitionStyle = .crossDissolve
                        self.present(newViewController, animated: true, completion: nil)
                    }
                    UserDefaults.standard.set(100, forKey: "CoinBalance")
                    UserDefaults.standard.set(0, forKey: "BetAmount")
                }))
                
                present(alert, animated: true, completion: nil)
                return
            }
        
        
        let alert = UIAlertController(
            title: "Game Over",
            message: "You’ve exhausted your coins. Save your score and restart the game.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Add Score", style: .default, handler: { _ in
            // Navigate back to the previous screen
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddScoresViewController") as! AddScoresViewController
            newViewController.modalPresentationStyle = .fullScreen
            newViewController.score = "\(self.coinBalance)"
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }

    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    @IBAction func backbuttonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func addScorePressed(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ScoresViewController") as! ScoresViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        newViewController.score = "\(self.coinBalance)"
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }

}
