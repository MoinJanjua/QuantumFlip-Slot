//
//  ScoresViewController.swift
//  Jackpot Slots
//
//  Created by Unique Consulting Firm on 10/01/2025.
//

import UIKit

class ScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameLb: UILabel!
    @IBOutlet weak var scorelb: UILabel!
    @IBOutlet weak var nodatalb: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var MainView: UIView!
    
    // MARK: - Data
    private var scores: [(name: String, score: Int, date: String, profileImageData: Data?)] = []
    private var sortedScores: [(name: String, score: Int, date: String, profileImageData: Data?)] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        nodatalb.isHidden = true
        loadScoresFromUserDefaults()
        
        
    }
    
    // MARK: - Load Scores
    private func loadScoresFromUserDefaults() {
        if let savedScores = UserDefaults.standard.array(forKey: "SlotGameScores") as? [[String: Any]] {
            scores = savedScores.compactMap {
                guard let name = $0["name"] as? String,
                      let score = $0["score"] as? Int,
                      let date = $0["date"] as? String else { return nil }
                
                let profileImageData = $0["profileImage"] as? Data // Extract image data
                
                return (name: name, score: score, date: date, profileImageData: profileImageData)
            }
            
            
        }
        
        if scores.isEmpty {
            nodatalb.isHidden = false
        }
        sortScoresAndUpdateUI()
    }
    
    
    // MARK: - Sorting and UI Update
    private func sortScoresAndUpdateUI() {
        
        if sortedScores.count > 0
        {
            usernameLb.text = "Top Player :\(sortedScores[0].name)"
            scorelb.text = "Top Scorer: \(sortedScores[0].score)"
        }
        // Reload table view
        tableView.reloadData()
        
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ScoresTableViewCell else {
            return UITableViewCell()
        }
        
        let score = sortedScores[indexPath.row]
        let rank = indexPath.row + 1
        
        // Configure cell
        cell.usernameLb.text = "Player Name: \(score.name)"
        cell.scorelb.text = "Scores: \(score.score)"
        cell.rankLb.text = "Rank: \(rank)"
        let cornerRadius: CGFloat = 15 // Adjust this value to control the roundness of the corners
        cell.profileImageView.layer.cornerRadius = cornerRadius
        cell.profileImageView.layer.masksToBounds = true
        
        if let imageData = score.profileImageData, let image = UIImage(data: imageData) {
            cell.profileImageView.image = image
        } else {
            cell.profileImageView.image = UIImage(named: "Defaultimage") // Use a default image if nil
        }
        
        // Update rank label color
        switch rank {
        case 1:
            cell.rankLb.textColor = .green
        case 2:
            cell.rankLb.textColor = .yellow
        case 3:
            cell.rankLb.textColor = .red
        default:
            cell.rankLb.textColor = .white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteScore(at: indexPath.row)
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func deleteScore(at index: Int) {
        // Remove the score at the index
        scores.remove(at: index)
        
        // Update the sortedScores list
        sortedScores = scores.sorted { $0.score > $1.score }
        
        // Update UserDefaults
        let updatedScores = scores.map { score in
            return ["name": score.name, "score": score.score, "date": score.date, "profileImage": score.profileImageData ?? Data()]
        }
        UserDefaults.standard.set(updatedScores, forKey: "SlotGameScores")
    }
    
    
    
    
    @IBAction func backbuttonPressed(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
}
