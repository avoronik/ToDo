//
//  ViewController.swift
//  UITableView
//
//  Created by Anastasia on 10/03/24.
//

import UIKit



class ViewController: UIViewController, newCellDelegate {
   
   
    var newNote: [Note] = []
    var completed: [Note] = []
    
//    let attrString = NSMutableAttributedString(string: note.title)
//    attrString.addAttributes([
//        .foregroundColor: UIColor.systemRed
//    ], range: NSRange(location: .zero, length: 1))
//    attrString.addAttributes([
//        .font: UIFont(name: "MONO PQU", size: 20)!
//    ], range: NSRange(location: .zero, length: attrString.string.count))
//    firstTitle.attributedText = attrString
//    
    private var mainTitle: UILabel = {
    var mainTitle = UILabel()
       let getDate = Date()
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            return dateFormatter
        }()
        
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.backgroundColor = .clear
        mainTitle.textColor = .black
        let text =  "\(dateFormatter.string(from: getDate))"
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttributes([.foregroundColor: UIColor.systemRed
        ], range: NSRange(location: 0, length: 2))
        mainTitle.attributedText = attrString
        mainTitle.numberOfLines = 2
        mainTitle.font = (UIFont(name: "MONO PQU", size: 35))
//            .monospacedSystemFont(ofSize: 30, weight: .heavy)

           
        mainTitle.textAlignment = .left
        return mainTitle
    }()
  
    
    lazy var notesCounter = makeNotesCounter()
    lazy var tableView = makeTableView()
    
    var note: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        setupUI()
    }

    func noteIsDone(cell: newCellTableViewCell) {
        guard let index = tableView.indexPath(for: cell) else {return}
        
        switch index.section {
        case 0:
            if index.row < newNote.count {
                var added = newNote[index.row]
                added.isCompleted.toggle()
                completed.append(added)
                newNote.remove(at: index.row)
            }
        case 1:
            if index.row < completed.count {
                var isDone = completed[index.row]
                isDone.isCompleted.toggle()
                newNote.append(isDone)
                completed.remove(at: index.row)
            }
        default:
                print("cell not found")
        }
        updNotesCounter()
        tableView.reloadData()
    }
}
  

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return newNote.count
        } else if section == 1 {
            return completed.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(newCellTableViewCell.self)", for: indexPath) as? newCellTableViewCell else { fatalError("cell not found")
        }
        
        switch indexPath.section {
        case 0:
            
            if indexPath.row < newNote.count {
                let newNoteCell = newNote[indexPath.row]
                cell.delegate = self
                cell.addNote(note: newNoteCell, isCompleted: false)
            }
        case 1:

            if  indexPath.row < completed.count {
                let completedCell = completed[indexPath.row]
                cell.delegate = self
                cell.addNote(note: completedCell, isCompleted: true)
                
            }
        default:
            let cellDefault = UITableViewCell()
            return cellDefault
        }
        updNotesCounter()
        return cell
       
    }
}
    

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell selected: section \(indexPath.section), row: \(indexPath.row)")
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch indexPath.section {
            case 0:
                newNote.remove(at: indexPath.row)
               
            case 1:
                completed.remove(at: indexPath.row)
                
            default:
                print("nothing to delete")
            }
//            tableView.deleteRows(at: [indexPath], with: .fade)
            updNotesCounter()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//       
//        newNote.swapAt(sourceIndexPath.row, destinationIndexPath.row)
//       
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Incompleted"
        case 1:
            return "Completed"
        default:
            return "Unknown section"
        }
    }
}

    private extension ViewController {
        
        func setupUI() {
            
            view.addSubview(tableView)
            view.addSubview(mainTitle)
            view.addSubview(notesCounter)
            
            NSLayoutConstraint.activate([
                
                mainTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                mainTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                mainTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
                mainTitle.heightAnchor.constraint(equalToConstant: 80),
                
                notesCounter.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 5),
                notesCounter.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                notesCounter.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                notesCounter.heightAnchor.constraint(equalToConstant: 25),
                
                tableView.topAnchor.constraint(equalTo: notesCounter.bottomAnchor, constant: 5),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
               
            ])
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEditButton))
            editButton.tintColor = .black
            
            self.navigationItem.leftBarButtonItem = editButton
            
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
            addButton.tintColor = .black
            
            self.navigationItem.rightBarButtonItem = addButton
        }
        
       
        func makeNotesCounter() -> UILabel {
            let counter = UILabel()
            counter.translatesAutoresizingMaskIntoConstraints = false
            counter.backgroundColor = .clear
            counter.textColor = .black
            counter.font = (UIFont(name: "MONO PQU", size: 15))
            counter.textAlignment = .left
            counter.text = "In Complete: \(newNote.count), Completed: \(completed.count)"
            
            return counter
        }
        
        func updNotesCounter() {
            let counter = notesCounter
            let text = "In Complete: \(newNote.count), Completed: \(completed.count)"
            counter.text = text
        }
        
        func makeTableView() -> UITableView {
            
            let table = UITableView(frame: .zero, style: .plain)
            table.translatesAutoresizingMaskIntoConstraints = false
            table.delegate = self
            table.dataSource = self
            // регистрация кастомной ячейки, имя файла ячейки, бандл нил, тк ячейка находится в одном файле с проектом
            
            table.register(UINib(nibName: "newCellTableViewCell", bundle: nil ), forCellReuseIdentifier: "newCellTableViewCell")
            
            return table
        }
        
        @objc
        func tapEditButton() {
            
            tableView.isEditing = !tableView.isEditing
        }
        
        @objc
        func addItem() {
//            tableView.reloadData()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else {return}
            vc.delegate = self
            
            
           self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
extension ViewController: DetailsViewControllerDelegate {
    func save(data: Note) {
        newNote.append(data)
        tableView.reloadData()
    }
}


    

//ндекс соответствует ячейке сегмент контроля - index
// model[index].count - достаем массив данных относящихся к группе сегмент контроля
// model[index][indexPath.row] - для того, чтобы вытянуть конкретный элемент из массива - это будет тайтл

