//
//  NormalViewController.swift
//  ImageViewer
//
//  Created by ZhaoWei on 16/2/23.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit
import CPImageViewer

class GeneralViewController: UIViewController, CPImageViewerProtocol {
    
    var isPresented = false
    
    @IBOutlet var animationImageView: UIImageView?
    var animator = CPImageViewerAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(GeneralViewController.tap))
        animationImageView?.addGestureRecognizer(tap)
        animationImageView?.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !isPresented {
            navigationController?.delegate = nil
        }
    }

    @objc func tap() {
        if !isPresented {
            navigationController?.delegate = animator
            
            let controller = CPImageViewer(style: CPImageViewer.Style.push)
            controller.image = animationImageView!.image
            controller.title = "CPImageViewer"
            controller.rightBarItemTitle = "Delete"
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = CPImageViewer()
            controller.image = animationImageView!.image
            present(controller, animated: true, completion: nil)
        }
    }
}
