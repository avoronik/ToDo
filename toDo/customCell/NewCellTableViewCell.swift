//
//  newCellTableViewCell.swift
//  toDoList2
//
//  Created by Anastasia on 14/04/24.
//

import UIKit

protocol NewCellDelegate: AnyObject {
    func noteIsDone(at index: IndexPath)
}

class NewCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var secondTitle: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    
    @IBOutlet weak var dateField: UILabel!
    weak var delegate: NewCellDelegate?
    
    var index: IndexPath?
    
    private let checkmark: UIButton =  {
        let checkmark = UIButton(type: .custom)
        checkmark.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        checkmark.tintColor = .black
        return checkmark
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        return dateFormatter
    }()
    
    func setup(note: Note, at index: IndexPath) {
        
        checkmark.setImage(UIImage(systemName: note.isCompleted ? "checkmark.circle.fill" : "checkmark.circle"), for: .normal)
        
        let attrString = NSMutableAttributedString(string: note.title)
        attrString.addAttributes([
            .foregroundColor: UIColor.systemRed
        ], range: NSRange(location: .zero, length: 1))
        attrString.addAttributes([
            .font: UIFont(name: "MONO PQU", size: 20)!
        ], range: NSRange(location: .zero, length: attrString.string.count))
        
        firstTitle.attributedText = attrString
        secondTitle.text = note.group
        groupImage.image = note.image
        dateField.text = "(till \(dateFormatter.string(from: note.date)))"
       
        self.index = index
        
        let today = Date().startOfDay
        if note.date < today {
            self.backgroundColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 0.5)
            firstTitle.textColor = .black
            firstTitle.font = UIFont(name:  "MONO PQU", size: 20)
            secondTitle.textColor = .black
            dateField.text = "(\(dateFormatter.string(from: note.date)) - expired)"
        } 
        if note.date >= today {
            self.backgroundColor = .clear
        }
    }
    
    
    @objc private func checkmarkDone(_ sender: UIButton) {
        guard let index = index else {return}
        delegate?.noteIsDone(at: index)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        
        firstTitle.textColor = .black
        firstTitle.textAlignment = .left
        firstTitle.numberOfLines = 2
        firstTitle.font = .monospacedSystemFont(ofSize: 20, weight: .regular)
        
        secondTitle.textColor = .systemGray
        secondTitle.textAlignment = .left
        secondTitle.numberOfLines = 1
        secondTitle.font = .systemFont(ofSize: 13, weight: .thin)

        groupImage.tintColor = .black
        
        dateField.font = UIFont(name: "MONO PQU", size: 15)
        dateField.textColor = .black
        
        accessoryView = checkmark
        checkmark.addTarget(self, action: #selector(checkmarkDone), for: .touchUpInside)

    }
}
    
extension Date {
    var startOfDay: Date  {
        return Calendar.current.startOfDay(for: self)
    }
}
