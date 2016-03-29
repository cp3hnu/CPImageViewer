//
//  NormalViewController.swift
//  ImageViewer
//
//  Created by ZhaoWei on 16/2/23.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

class GeneralViewController: UIViewController, CPImageControllerProtocol {
    
    var isPresented = false
    
    @IBOutlet var animationImageView: UIImageView!
    var animator = CPImageViewerAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(GeneralViewController.tap))
        animationImageView.addGestureRecognizer(tap)
        animationImageView.userInteractionEnabled = true
        
        if !isPresented {
            self.navigationController?.delegate = animator
        }
    }

    func tap() {
        let controller = CPImageViewerViewController()
        controller.transitioningDelegate = animator
        controller.image = animationImageView.image
        
        if !isPresented {
            controller.viewerStyle = .Push
            controller.title = "CPImageViewer"
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
}
