//
//  AddScoresViewController.swift
//  QuantumFlip slot
//
//  Created by Unique Consulting Firm on 14/02/2025.
//

import UIKit

class AddScoresViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var genderDropDown: DropDown!
    
    @IBOutlet weak var MainView: UIView!

    @IBOutlet weak var addscore: UIButton!
    var score = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
       
       // applyCornerRadiusToBottomCorners(view: MainView, cornerRadius: 25)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        setupGenderDropDown()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
        scoreTextField.resignFirstResponder()
    }
    
    private func setupUI() {
        // Set the score in text field
        scoreTextField.text = score
        
        // Make profile image view interactive
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    private func setupGenderDropDown() {
        genderDropDown.optionArray = ["Male", "Female"]
        genderDropDown.selectedIndex = 0 // Default selection
        genderDropDown.didSelect { (selectedText, index, id) in
            self.genderDropDown.text = selectedText
        }
    }
    
    private func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Format as needed
        return formatter.string(from: Date())
    }
    
    @objc private func selectProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Handle image selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            profileImageView.image = selectedImage
        } else if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let playerName = usernameTextField.text, !playerName.isEmpty,
              let scoreText = scoreTextField.text, !scoreText.isEmpty,
              let scoreValue = Int(scoreText),
              let selectedGender = genderDropDown.text else { // Using `.text` instead of `selectedItem`
            showAlert(title: "Error!", message: "Please fill in all details correctly.")
            return
        }
        
        let currentDate = getCurrentDateTime()
        
        var savedScores = UserDefaults.standard.array(forKey: "SlotGameScores") as? [[String: Any]] ?? []
        
        let imageData = profileImageView.image?.jpegData(compressionQuality: 0.8)

        let newRecord: [String: Any] = [
            "name": playerName,
            "score": scoreValue,
            "date": currentDate,
            "gender": selectedGender,
            "profileImage": imageData ?? Data()
        ]
        
        savedScores.append(newRecord)
        UserDefaults.standard.set(savedScores, forKey: "SlotGameScores")

        UserDefaults.standard.set(100, forKey: "CoinBalance")
        UserDefaults.standard.set(0, forKey: "BetAmount")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let scoresVC = storyboard.instantiateViewController(withIdentifier: "ScoresViewController") as? ScoresViewController {
            scoresVC.modalPresentationStyle = .fullScreen
            scoresVC.modalTransitionStyle = .crossDissolve
            present(scoresVC, animated: true, completion: nil)
        }
    }
    @IBAction func btnback(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    
    }

   
}
