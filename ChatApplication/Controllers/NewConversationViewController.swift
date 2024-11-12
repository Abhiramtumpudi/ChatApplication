//
//  NewConversationViewController.swift
//  ChatApplication
//
//  Created by Abhiram Tumpudi on 17/08/24.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    var users = [[String : String]]()
    
    var results = [[String : String]]()
    
    var hasFetched = false
    
    private var searchBar : UISearchBar = {
        let UISearchBar = UISearchBar()
        UISearchBar.placeholder = "Search for Users"
        return UISearchBar
    }()
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    private let noUserLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21 , weight: .medium)
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(noUserLabel)
        view.addSubview(tableView)
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noUserLabel.frame = CGRect(x: view.width/4 ,
                                   y: (view.height - 200 ) / 2,
                                   width: view.width/2,
                                   height: 200)
    }
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewConversationViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
}

extension NewConversationViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         
        guard let text = searchBar.text , !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        searchBar.resignFirstResponder()
        results.removeAll()
        spinner.show(in: view)
        self.searchUsers(query: text)
        
    }
    
    func searchUsers(query : String) {
        // check if array has firbase results
        if hasFetched {
            // if it does filter it
            self.filerResults(with: query)
            
        } else {
            // if not fetcxh filter ,
            DatabaseManager.shared.getAllUsers { [weak self] results in
                switch results {
                case .success(let userCollection):
                    self?.hasFetched = true
                    self?.users = userCollection
                    self?.filerResults(with: query)
                case .failure(let error):
                    print("failed to fetch \(error)")
                }
            }
        }
        // update the UI with show results or update with no results
    }
    
    func filerResults(with term : String) {
        guard hasFetched else {
            return
        }
        self.spinner.dismiss()
        let results = self.users.filter({
            guard let name = $0["name"] else {
                return false
            }
            return name.hasPrefix(term)
        })
        self.results = results
        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            self.noUserLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.noUserLabel.isHidden = true
            self.tableView.isHidden = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
           
        }
    }
}
