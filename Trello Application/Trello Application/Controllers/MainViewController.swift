//
//  ViewController.swift
//  Trello Application
//
//  Created by liene.krista.neimane on 23/09/2023.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var boardsTableView: UITableView!
    
    var dataSource: [String] = []
    var isAuthorized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Boards"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        emptyLabel.isHidden = true
        emptyImageView.isHidden = true

        configureSearchBar()
        configureTableView()
        
        boardsTableView.delegate = self
        boardsTableView.dataSource = self
        
        if dataSource.isEmpty {
            emptyLabel.isHidden = false
            emptyImageView.isHidden = false
        } else {
            emptyLabel.isHidden = true
            emptyImageView.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isAuthorized {
            isAuthorized = true
            performSegue(withIdentifier: "Authorize", sender: self)
        }
    }

    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.text = ""
        searchBar.placeholder = "Search..."
        searchBar.backgroundImage = UIImage()
    }
    
    func configureTableView() {
        let borderView = UIView(frame: CGRect(x: 0, y: 0, width: boardsTableView.frame.size.width, height: 1))
        borderView.backgroundColor = .systemGray
        boardsTableView.addSubview(borderView)
        
        boardsTableView.backgroundColor = UIColor.systemGray5
    }
    
    // Dummy test
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }


}
