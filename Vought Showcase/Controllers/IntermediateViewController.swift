//
//  IntermediateViewController.swift
//  Vought Showcase
//
//  Created by Pradyut Fogla on 30/08/24.
//

import Foundation
import UIKit

class IntermediateViewController: UIViewController {
    
    private let launchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Launch Story", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(launchButton)
        NSLayoutConstraint.activate([
            launchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            launchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        launchButton.addTarget(self, action: #selector(launchCarousel), for: .touchUpInside)
    }
    
    @objc private func launchCarousel() {
        let carouselItemProvider = CarouselItemDataSourceProvider()
        let carouselViewController = CarouselViewController(items: carouselItemProvider.items())
        
        carouselViewController.modalPresentationStyle = .fullScreen
        carouselViewController.transitioningDelegate = self
        
        present(carouselViewController, animated: true, completion: nil)
    }
}

extension IntermediateViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomUpPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class BottomUpPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return containerView.bounds
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView,
              let presentedView = presentedView else { return }
        
        presentedView.frame = frameOfPresentedViewInContainerView
        containerView.addSubview(presentedView)
        
        presentedView.transform = CGAffineTransform(translationX: 0, y: containerView.bounds.height)
        
        UIView.animate(withDuration: 0.3) {
            presentedView.transform = .identity
        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.presentedView?.transform = CGAffineTransform(translationX: 0, y: containerView.bounds.height)
        }
    }
}
