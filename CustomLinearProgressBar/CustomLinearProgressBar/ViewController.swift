//
//  ViewController.swift
//  CustomLinearProgressBar
//
//  Created by J_Min on 2022/11/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circleProgress: CircleProgress!
    @IBOutlet weak var lineProgress: LineProgress!
    @IBOutlet weak var circleLineProgressBar: CircleLineProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func startAnimationButtonAction(_ sender: UIButton) {
        circleProgress.startAnimation(to: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.circleProgress.startAnimation(to: 1)
            self?.lineProgress.startAnimation(duration: 0.5)
        }
    }
    
    @IBAction func repButtonAction(_ sender: UIButton) {
        circleLineProgressBar.updateCircleProgress()
    }
}

