//
//  DeleteImageViewController.swift
//  EdusnsClient
//
//  Created by ZhaoWei on 16/2/2.
//  Copyright © 2016年 csdept. All rights reserved.
//

import UIKit

public class CPImageViewer: UIViewController {
    public enum Style {
        /// Present style
        case presentation
        
        /// Navigation style
        case push
    }
    
    /// The image of animation image view
    public var image: UIImage?
    
    /// The title of *navigationItem.rightBarButtonItem* when viewerStyle is Push
    public var rightBarItemTitle: String?
    
    /// The image of *navigationItem.rightBarButtonItem* when viewerStyle is Push
    public var rightBarItemImage: UIImage?
    
    /// The action of *navigationItem.rightBarButtonItem* when viewerStyle is Push
    public var rightAction: (() -> Void)?
    
    /// The Image View
    private var imageView: UIImageView!
    /// The viewer style. Defaults to **presentation**
    private let style: CPImageViewer.Style
    /// The animator
    private let animator = CPImageViewerAnimator()
    private var scrollView: UIScrollView!
    private var isViewDidAppear = false
    
    public init(style: CPImageViewer.Style = .presentation) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
        
        // Solving the error of location of image view after rotating device and returning to previous controller.
        
        if style == .presentation {
            transitioningDelegate = animator
            modalPresentationStyle = .overFullScreen
            modalPresentationCapturesStatusBarAppearance = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.black
        scrollView.maximumZoomScale = 5.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        if #available(iOSApplicationExtension 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["scrollView" : scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["scrollView" : scrollView]))
        
        imageView = UIImageView()
        imageView.image = image
        scrollView.addSubview(imageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissImageViewer))
        scrollView.addGestureRecognizer(tap)
        
        if style == .push {
            if let title = rightBarItemTitle {
                let rightItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarItemAction))
                navigationItem.rightBarButtonItem = rightItem
            } else if let image = rightBarItemImage {
                let rightItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rightBarItemAction))
                navigationItem.rightBarButtonItem = rightItem
            }
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isViewDidAppear = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.zoomScale = 1.0
        scrollView.contentInset = UIEdgeInsets.zero
        imageView.frame = centerFrameForImageView()
    }
    
    public override var prefersStatusBarHidden: Bool {
        if style == .presentation && isViewDidAppear {
            return true
        }
        
        return super.prefersStatusBarHidden
    }
}

// MARK: - Help
private extension CPImageViewer {
    func centerFrameForImageView() -> CGRect {
        guard let aImage = image else { return CGRect.zero }
        
        let viewWidth = scrollView.frame.size.width
        let viewHeight = scrollView.frame.size.height
        let imageWidth = aImage.size.width
        let imageHeight = aImage.size.height
        let newWidth = min(viewWidth, CGFloat(floorf(Float(imageWidth * (viewHeight / imageHeight)))))
        let newHeight = min(viewHeight, CGFloat(floorf(Float(imageHeight * (viewWidth / imageWidth)))))
        
        return CGRect(x: (viewWidth - newWidth)/2, y: (viewHeight - newHeight)/2, width: newWidth, height: newHeight)
    }
    
    func centerScrollViewContents() {
        let viewWidth = scrollView.frame.size.width
        let viewHeight = scrollView.frame.size.height
        let imageWidth = imageView.frame.size.width
        let imageHeight = imageView.frame.size.height
        
        let originX = max(0, (viewWidth - imageWidth)/2)
        let originY = max(0, (viewHeight - imageHeight)/2)
        imageView.frame.origin = CGPoint(x: originX, y: originY)
    }
}

// MARK: - Action
private extension CPImageViewer {
    @objc func rightBarItemAction() {
        if let block = rightAction {
            block()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func dismissImageViewer() {
        if style == .presentation {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - CPImageViewerProtocol
extension CPImageViewer: CPImageViewerProtocol {
    public var animationImageView: UIImageView? {
        return imageView
    }
}

// MARK: - UIScrollViewDelegate
extension CPImageViewer: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
}
