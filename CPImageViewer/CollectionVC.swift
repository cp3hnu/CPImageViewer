//
//  CollectionVC.swift
//  CPImageViewerExample
//
//  Created by CP3 on 2018/9/26.
//  Copyright © 2018 cp3hnu. All rights reserved.
//

import UIKit
import CPImageViewer

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CPImageViewerProtocol {
    
    var originalFrame: CGRect?
    

    @IBOutlet var collectionView: UICollectionView!
    var isPresented = false
    var animationImageView: UIImageView?
    var animator = CPImageViewerAnimator()
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if !isPresented {
            navigationController?.delegate = animator
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        computeOriginalFrame()
    }
    
    func computeOriginalFrame() {
        if let path = indexPath, let imgView = animationImageView {
            if let attr = self.collectionView.layoutAttributesForItem(at: path) {
                let frame = self.collectionView.convert(attr.frame, to: self.view)
                print("computeOriginalFrame", attr.frame, frame)
                let imgFrame = frame.offsetBy(dx: 10, dy: 10)
                originalFrame = CGRect(origin: imgFrame.origin, size: imgView.bounds.size)
                self.navigationController?.originalFrame = originalFrame
            }
        }
    }
    
    func clearOriginalFrame() {
        self.originalFrame = nil
        self.navigationController?.originalFrame = nil
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        // Configure the cell
        cell.imageView.image = UIImage(named: "\(indexPath.item + 1)")
        cell.label.text = "\(indexPath.item + 1)"
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        
        self.animationImageView = cell.imageView
        self.indexPath = indexPath
        self.clearOriginalFrame()
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
