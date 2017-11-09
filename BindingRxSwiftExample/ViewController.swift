//
//  ViewController.swift
//  BindingRxSwiftExample
//
//  Created by Alper Akinci on 08/11/2017.
//  Copyright © 2017 Alper Akinci. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var circleView: UIView!
    fileprivate var circleViewModel : CircleViewModel!
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // Draw a circle in the main view of controller
    func setup() {
        // Add circle view
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = .green
        view.addSubview(circleView)

        // Add gesture recognizer
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)

        circleViewModel = CircleViewModel()
        /**
         Observe ball’s center position using rx.observe()
         and then bind it to a Variable, using bindTo().

         But what does binding do in our case? Well, every time a new position is emitted by our ball, the variable will receive a new signal about it.
         In this case our variable is an Observer, because it will observe the position.
        */
        circleView
            .rx
            .observe(CGPoint.self, "center")
            .bind(to: circleViewModel.centerVariable)
            .disposed(by: disposeBag)

        /**
         Changing the background color of our view to the complementary color of our ball.
        */
        circleViewModel.backgroundColorOnbservable.subscribe(onNext: { [weak self] backgroundColor in
            UIView.animate(withDuration: 0.1) {
                self?.circleView.backgroundColor = backgroundColor
                // Try to get complementary color for given background color
                let viewBackgroundColor = UIColor(complementaryFlatColorOf: backgroundColor)
                // If it is different that the color
                if viewBackgroundColor != backgroundColor {
                    // Assign it as a background color of the view
                    // We only want different color to be able to see that circle in a view
                    self?.view.backgroundColor = viewBackgroundColor
                }
            }
        }).disposed(by: disposeBag)

    }

    @objc func circleMoved(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }

}

