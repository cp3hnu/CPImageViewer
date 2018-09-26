//
//  InteractiveTransition.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

final class CPImageViewerInteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning {
    
    /// Be true when Present, and false when Push
    var isPresented = true
    
    /// Whether is interaction in progress. Default is false
    private(set) var interactionInProgress = false
    
    private weak var imageViewer: CPImageViewer!
    private let distance = UIScreen.main.bounds.height/2
    private var shouldCompleteTransition = false
    private var startInteractive = false
    private var transitionContext: UIViewControllerContextTransitioning?
    private var toVC: UIViewController!
    private var newImageView: UIImageView!
    private var backgroundView: UIView!
    private var toImageView: UIImageView!
    private var fromFrame: CGRect = CGRect.zero
    private var toFrame: CGRect = CGRect.zero
    private var style = UIModalPresentationStyle.fullScreen
    
    /**
     Install the pan gesture recognizer on view of *vc*
     
     - parameter vc: The *CPImageViewer* view controller
     */
    func wireToImageViewer(_ imageViewer: CPImageViewer) {
        self.imageViewer = imageViewer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(CPImageViewerInteractiveTransition.handlePan(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        panGesture.delegate = self
        imageViewer.view.addGestureRecognizer(panGesture)
    }

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        startInteractive = true
        self.transitionContext = transitionContext
        style = transitionContext.presentationStyle
        
        toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        // Solving the error of location of image view after rotating device and returning to previous controller. See CPImageViewer.init()
        // The overFullScreen style don't need add toVC.view
        // The style is none when CPImageViewer.style is CPImageViewer.Style.push
        if style != .overFullScreen {
            containerView.addSubview(toVC.view)
            containerView.sendSubviewToBack(toVC.view)
            
            toVC.view.frame = finalFrame
            toVC.view.setNeedsLayout()
            toVC.view.layoutIfNeeded()
        }
        
        backgroundView = UIView(frame: finalFrame)
        backgroundView.backgroundColor = UIColor.black
        containerView.addSubview(backgroundView)
        
        let fromImageView: UIImageView! = imageViewer.animationImageView
        toImageView = (toVC as! CPImageViewerProtocol).animationImageView
        fromFrame = fromImageView.convert(fromImageView.bounds, to: containerView)
        toFrame = toImageView.convert(toImageView.bounds, to: containerView)
        
        // Solving the error of location of image view in UICollectionView after rotating device and returning to previous controller
        if let frame = (toVC as! CPImageViewerProtocol).originalFrame {
            //print("frame = ", frame)
            toFrame = toVC.view.convert(frame, to: containerView)
            //print("toFrame = ", toFrame)
        }
        
        newImageView = UIImageView(frame: fromFrame)
        newImageView.image = fromImageView.image
        newImageView.contentMode = .scaleAspectFit
        containerView.addSubview(newImageView)
        
        imageViewer.view.alpha = 0.0
    }
}

// MARK: - UIPanGestureRecognizer
private extension CPImageViewerInteractiveTransition {
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        let currentPoint = gesture.translation(in: imageViewer.view)
        switch (gesture.state) {
        case .began:
            interactionInProgress = true
            if isPresented {
                imageViewer.dismiss(animated: true, completion: nil)
            } else {
                _ = imageViewer.navigationController?.popViewController(animated: true)
            }
            
        case .changed:
            updateInteractiveTransition(currentPoint)
            
        case .ended, .cancelled:
            interactionInProgress = false
            if (!shouldCompleteTransition || gesture.state == .cancelled) {
                cancelTransition()
            } else {
                completeTransition()
            }
            
        default:
            break
        }
    }
}

// MARK: - Update & Complete & Cancel
private extension CPImageViewerInteractiveTransition {
    func updateInteractiveTransition(_ currentPoint: CGPoint) {
        guard startInteractive else { return }
            let percent = min(abs(currentPoint.y) / distance, 1)
        
        shouldCompleteTransition = (percent > 0.3)
        transitionContext?.updateInteractiveTransition(percent)
        backgroundView.alpha = 1 - percent
        newImageView.frame.origin.y = fromFrame.origin.y + currentPoint.y
        
        if (fromFrame.width > UIScreen.main.bounds.size.width - 60)
        {
            newImageView.frame.size.width = fromFrame.width - percent * 60.0
            newImageView.frame.origin.x = fromFrame.origin.x + percent * 30.0
        }
    }
    
    func completeTransition() {
        guard startInteractive else { return }
        
        let duration = 0.3
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.newImageView.frame = self.toFrame
            self.backgroundView.alpha = 0.0
        }, completion: { finished in
            self.startInteractive = false
            
            self.newImageView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
            
            self.toImageView.alpha = 1.0
            
            self.transitionContext?.finishInteractiveTransition()
            self.transitionContext?.completeTransition(true)
        })
    }
    
    func cancelTransition() {
        guard startInteractive else { return }
        
        let duration = 0.3
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.newImageView.frame = self.fromFrame
            self.backgroundView.alpha = 1.0
        }, completion: { finished in
            self.startInteractive = false
            
            self.newImageView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
            
            self.imageViewer.view.alpha = 1.0
            if self.style != .overFullScreen {
                self.toVC.view.removeFromSuperview()
            }
            
            self.transitionContext?.cancelInteractiveTransition()
            self.transitionContext?.completeTransition(false)
        })
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CPImageViewerInteractiveTransition: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let currentPoint = panGesture.translation(in: imageViewer.view)
            return abs(currentPoint.y) > abs(currentPoint.x)
        }
        
        return true
    }
}
