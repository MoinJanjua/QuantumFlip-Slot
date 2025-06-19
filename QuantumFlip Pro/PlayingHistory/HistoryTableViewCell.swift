import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLb: UILabel!
    @IBOutlet weak var scorelb: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var genderLb: UILabel!  // New label for gender
    @IBOutlet weak var dateLb: UILabel!    // New label for date
    @IBOutlet weak var containerView: UIView! // Add an IBOutlet for a container view
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Round profile image
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true

        // Round container view
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true

        // Add shadow effect to the cell
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.1
        self.contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.contentView.layer.shadowRadius = 5
        
        // Ensure proper spacing
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15) // Set padding for each cell
        self.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) // Set separator spacing
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure the shadow is applied properly
        self.contentView.layer.shadowPath = UIBezierPath(roundedRect: self.contentView.bounds, cornerRadius: 15).cgPath
        
        // Adjust layout margins for spacing inside the cell
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)  // Adjust these values for padding
        
        // Adjust separator insets for spacing between cells
        self.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}
