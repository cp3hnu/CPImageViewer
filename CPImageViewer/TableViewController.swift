//
//  TableViewController.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit
import CPImageViewer

private let reuseIdentifier = "Cell"

class TableViewController: UITableViewController, CPImageViewerProtocol {

    var isPresented = false
    var animationImageView: UIImageView?
    var animator = CPImageViewerAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isPresented {
            navigationController?.delegate = animator
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let name = "\(indexPath.row + 1)"
        let imageView = cell.contentView.viewWithTag(100) as! UIImageView
        let label = cell.contentView.viewWithTag(101) as! UILabel
        imageView.image = UIImage(named: name)
        label.text = name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        let imageView = cell!.contentView.viewWithTag(100) as! UIImageView
        
        animationImageView = imageView

        tap()
    }
    
    func tap() {
        if !isPresented {
            let controller = CPImageViewer(style: CPImageViewer.Style.push)
            controller.image = animationImageView!.image
            controller.title = "CPImageViewer"
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = CPImageViewer()
            controller.image = animationImageView!.image
            present(controller, animated: true, completion: nil)
        }
    }

}
