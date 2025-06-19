//
//  HistoryViewController.swift
//
//  Created by Unique Consulting Firm on 11/01/2025.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nodatalb: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var MainView: UIView!

    // MARK: - Data
    private var scores: [(name: String, score: Int, date: String, gender: String, profileImageData: Data?)] = []
    private var sortedScores: [(name: String, score: Int, date: String, gender: String, profileImageData: Data?)] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        nodatalb.isHidden = true
        loadScoresFromUserDefaults()

            tableView.rowHeight = 120 // Row height with space
            tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0) // Add space around the table view
            tableView.sectionHeaderTopPadding = 20 // Space before the first cell of each section
            
            tableView.separatorStyle = .singleLine
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.reloadData()

        }

    

    // MARK: - Load Scores
    private func loadScoresFromUserDefaults() {
        if let savedScores = UserDefaults.standard.array(forKey: "SlotGameScores") as? [[String: Any]] {
            scores = savedScores.compactMap {
                guard let name = $0["name"] as? String,
                      let score = $0["score"] as? Int,
                      let date = $0["date"] as? String,
                      let gender = $0["gender"] as? String else { return nil }

                let profileImageData = $0["profileImage"] as? Data

                return (name: name, score: score, date: date, gender: gender, profileImageData: profileImageData)
            }
        }

        // Sort by highest score
        sortedScores = scores.sorted { $0.score > $1.score }

        // Show/hide "No Data" label
        nodatalb.isHidden = !sortedScores.isEmpty

        // Reload table view after sorting
        tableView.reloadData()
    }


    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        let score = sortedScores[indexPath.row]
        
        // Configure cell
        cell.usernameLb.text = score.name
        cell.scorelb.text = "Scores: \(score.score)"
        cell.genderLb.text = "Gender: \(score.gender)" // Display gender
        cell.dateLb.text = "Date: \(score.date)" // Display date
        
        // Convert Data to UIImage
        if let imageData = score.profileImageData, let image = UIImage(data: imageData) {
            cell.profileImageView.image = image
        } else {
            cell.profileImageView.image = UIImage(named: "Defaultimage") // Use a default image if nil
        }
        
        // Make profile image circular
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height / 2
        cell.profileImageView.layer.masksToBounds = true
            
        // Update rank label color
       
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // Adds space before the first cell in each section
    }


    // MARK: - Delete Score
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteScore(at: indexPath.row)
        }
    }

    private func deleteScore(at index: Int) {
        // Find the actual index in the original scores array
        guard index < sortedScores.count else { return }  // Prevent out-of-bounds crash
        
        let scoreToRemove = sortedScores[index]  // Get the selected score
        if let originalIndex = scores.firstIndex(where: {
            $0.name == scoreToRemove.name &&
            $0.score == scoreToRemove.score &&
            $0.date == scoreToRemove.date &&
            $0.gender == scoreToRemove.gender
        }) {
            scores.remove(at: originalIndex)  // Remove from the original array
        }

        // Update sortedScores and refresh table
        sortedScores = scores.sorted { $0.score > $1.score }
        
        // Update UserDefaults
        let updatedScores = scores.map { score in
            return ["name": score.name, "score": score.score, "date": score.date, "gender": score.gender, "profileImage": score.profileImageData ?? Data()]
        }
        UserDefaults.standard.set(updatedScores, forKey: "SlotGameScores")

        // Refresh table view
        tableView.reloadData()
    }


    // MARK: - Back Button
    @IBAction func backbuttonPressed(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        newViewController.modalPresentationStyle = .fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
}

