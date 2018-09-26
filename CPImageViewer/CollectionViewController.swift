//
//  CollectionViewController.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit
import CPImageViewer

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, CPImageViewerProtocol {

    var isPresented = false
    var animationImageView: UIImageView?
    var animator = CPImageViewerAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !isPresented {
            navigationController?.delegate = animator
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        cell.imageView.image = UIImage(named: "\(indexPath.item + 1)")
        cell.label.text = "\(indexPath.item + 1)"
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        
        animationImageView = cell.imageView
        
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
