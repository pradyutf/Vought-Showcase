//
//  ViewController.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //initCarouselView()
    }
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         //initCarouselView()
        showIntermediateViewController()

     }
    
    private func initCarouselView() {
        // Create a carousel item provider
        let carouselItemProvider = CarouselItemDataSourceProvider()
        
        // Create carouselViewController
        let carouselViewController = CarouselViewController(items: carouselItemProvider.items())
        
        // Present the carouselViewController full screen
        carouselViewController.modalPresentationStyle = .fullScreen
        present(carouselViewController, animated: true, completion: nil)
        
    }
    
    private func showIntermediateViewController() {
        let intermediateViewController = IntermediateViewController()
        addChild(intermediateViewController)
        containerView.addSubview(intermediateViewController.view)
        intermediateViewController.view.frame = containerView.bounds
        intermediateViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        intermediateViewController.didMove(toParent: self)
    }
    
}

