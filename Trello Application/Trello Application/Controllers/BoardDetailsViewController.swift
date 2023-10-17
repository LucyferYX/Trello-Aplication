//
//  BoardDetailsViewController.swift
//  Trello Application
//
//  Created by liene.krista.neimane on 09/10/2023.
//

import UIKit

class BoardDetailsViewController: UIViewController {
    @IBOutlet weak var BoardDetailsTableView: UITableView!
    
    override func viewDidLoad() {
        let url = URL(string: "https://trello.com/b/\(board.id)/.json")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let lists = json["lists"] as! [[String: Any]]
                    let cards = json["cards"] as! [[String: Any]]
                    // Parse lists and cards here...
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
