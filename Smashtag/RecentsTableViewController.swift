//
//  RecentsTableViewController.swift
//  Smashtag
//
//  Created by Ziheng Chen on 2/15/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class RecentsTableViewController: UITableViewController {

    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recents"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentsDatabase().getCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Recents", for: indexPath)
        cell.textLabel?.text = RecentsDatabase().getRecentSearch(row: indexPath.row)
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search Recent Term" {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let destinationController = segue.destination as? TweetTableViewController {
                destinationController.searchText = RecentsDatabase().getRecentSearch(row: indexPath.row)
            }
        }
    }
}
