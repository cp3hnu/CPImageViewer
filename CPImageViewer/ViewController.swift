//
//  ViewController.swift
//  ImageViewer
//
//  Created by ZhaoWei on 16/2/23.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "CPImageViewer Demo"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "General"
            
        case 1:
            cell.textLabel?.text = "TableView"
            
        case 2:
            cell.textLabel?.text = "CollectionVC"
            
        case 3:
            cell.textLabel?.text = "CollectionView"
        default:
            break
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Present"
        default:
            return "Navigation"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var isPresented = false
        if indexPath.section == 0 {
            isPresented = true
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var controller: UIViewController
        if indexPath.row == 0 {
            controller = storyboard.instantiateViewController(withIdentifier: "GeneralVC")
            (controller as! GeneralViewController).isPresented = isPresented
        } else if indexPath.row == 1 {
            controller = storyboard.instantiateViewController(withIdentifier: "TableVC")
            (controller as! TableViewController).isPresented = isPresented
        } else if indexPath.row == 2 {
            controller = storyboard.instantiateViewController(withIdentifier: "CollectionVC")
            (controller as! CollectionViewController).isPresented = isPresented
        } else {
            controller = storyboard.instantiateViewController(withIdentifier: "CollectionView")
            (controller as! CollectionVC).isPresented = isPresented
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

