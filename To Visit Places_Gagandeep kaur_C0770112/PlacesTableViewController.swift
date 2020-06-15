//
//  PlacesTableViewController.swift
//  To Visit Places_Gagandeep kaur_C0770112
//
//  Created by Mac on 6/15/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import MapKit

class PlacesTableViewController: UITableViewController {
    
    @IBOutlet var mTableView: UITableView!
    var index: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utilities.getNumber()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        let (_ , _ , name) = Utilities.get(index: indexPath.row)
        cell?.textLabel?.text = name
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            Utilities.remove(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}
