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
    
    let APIKey = "72e332ebe806f2444aaefc232b79699a"
    var boards: [Board] = []
    var filteredBoards: [Board] = []
    var isAuthorized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Boards"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        emptyLabel.isHidden = true
        emptyImageView.isHidden = true

        configureSearchBar()
        configureTableView()
        
        searchBar.delegate = self
        boardsTableView.delegate = self
        boardsTableView.dataSource = self
        
        if boards.isEmpty {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Authorize", let authorizationViewController = segue.destination as? AuthorizationViewController {
            authorizationViewController.delegate = self
        }
    }
    
    // Fetches the boards for table list with given token
    func fetchBoards(with token: String) {
        print("Started board fetching function.")
        let url = URL(string: "https://api.trello.com/1/members/me/boards?fields=name,url&key=\(APIKey)&token=\(token)")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Error: \(error)")
                }
                return
            }

            guard let data = data else { return }

            do {
                self.boards = try JSONDecoder().decode([Board].self, from: data)
                self.filteredBoards = self.boards
                DispatchQueue.main.async {
                    self.boardsTableView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error: \(error)")
                }
            }
        }.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBoards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! BoardsTableViewCell
        cell.boardLabel.text = filteredBoards[indexPath.row].name
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchTerms = searchText.split(separator: " ").map { String($0) }
        filteredBoards = boards.filter { board in
            searchText.isEmpty || searchTerms.allSatisfy { searchTerm in
                board.name.lowercased().contains(searchTerm.lowercased())
            }
        }
        boardsTableView.reloadData()
    }

}


extension MainViewController {
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
}

extension MainViewController: AuthorizationViewControllerDelegate {
    func authorizationViewController(_ controller: AuthorizationViewController, didFetchToken token: String) {
        fetchBoards(with: token)
    }
}

struct Board: Codable {
    let name: String
    let id: String
    let url: String
}
