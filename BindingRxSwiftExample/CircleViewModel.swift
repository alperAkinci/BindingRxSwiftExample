//
//  CircleViewModel.swift
//  BindingRxSwiftExample
//
//  Created by Alper Akinci on 08/11/2017.
//  Copyright © 2017 Alper Akinci. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import ChameleonFramework

class CircleViewModel {

    /**
     See, our observable center of ball is connected with centerVariable.
     It means that overtime the center changes, centerVariable will get the change.
     It is then an Observer.

     Also in our ViewModel we use centerVariable as an Observable, which makes it both Observer and Observable which is just a Subject.

     Why Variable and not PublishSubject, ReplaySubject?
     Because we want to be sure we will get the latest center of that ball every time we subscribe to it.

    */
    var centerVariable = Variable<CGPoint?>(CGPoint.zero)
    var backgroundColorOnbservable: Observable<UIColor>!

    init() {
        setup()
    }

    func setup(){
        /**
         1 - Transform our variable into Observable – since Variable can be both Observer and Observable, we need to decide which one is it.

         And since we want to observe it, we transform it into Observable.

         2 - Map every new value of CGPoint to UIColor.

         We get the new center that our Observable produced, then based on (not-so) really complicated math calculations we create new UIColor.

         You may notice that our Observable is an optional CGPoint.

         Why? We will explain it in a second. But we need to protect ourselves and in case we get nil, return some default color (black in our case).
        */
        backgroundColorOnbservable = centerVariable
            // 1
            .asObservable()
            // 2
            .map{ center in
                guard let center = center else { return UIColor.flatten(.black)() }

                let red: CGFloat = ((center.x + center.y).truncatingRemainder(dividingBy: 255.0)) / 255.0 // We just manipulate red, but you can do w/e
                let green: CGFloat = 0.0
                let blue: CGFloat = 0.0

                return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
        }
    }
}
