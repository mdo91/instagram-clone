//
//  NotificationViewController.swift
//  instegramClone
//
//  Created by Mdo on 12/01/2021.
//

import UIKit

class NotificationViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

 
    }
    
    //MARK: - configure ui
    
    private func configureUI(){
        
        self.tableView.separatorColor = .clear
        self.tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.reuseIdentifier)
        
        navigationItem.title = "Notifications"
        
    }

    // MARK: - Table view data source
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseIdentifier, for: indexPath) as? NotificationCell else{
            
            fatalError("could not init \(NotificationCell.self)")
        }
        
        return cell
    }

    

}
