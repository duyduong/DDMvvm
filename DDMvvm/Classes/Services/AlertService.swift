//
//  AlertService.swift
//  eSportLive
//
//  Created by Dao Duy Duong on 9/23/18.
//  Copyright © 2018 Nover. All rights reserved.
//

import UIKit
import RxSwift

class AlertPage: UIAlertController {
    
    private var alertWindow: UIWindow? = nil
    
    fileprivate func show() {
        let blankViewController = UIViewController()
        blankViewController.view.backgroundColor = .clear
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = blankViewController
        window.backgroundColor = .clear
        window.windowLevel = UIWindow.Level.alert + 1
        window.makeKeyAndVisible()
        alertWindow = window
        
        blankViewController.present(self, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // we only remove window when user clicked on button
        alertWindow?.isHidden = true
        alertWindow = nil
    }
    
}

public protocol IAlertService {
    func presentOkayAlert(title: String?, message: String?)
    
    func presentObservableOkayAlert(title: String?, message: String?) -> Observable<Void>
    func presentObservableConfirmAlert(title: String?, message: String?, yesText: String, noText: String) -> Observable<Bool>
    func presentObservaleActionSheet(title: String?, message: String?, actionTitles: [String], cancelTitle: String) -> Observable<String>
}

public class AlertService: IAlertService {
    
    public func presentOkayAlert(title: String? = "OK", message: String? = nil) {
        let alertPage = AlertPage(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel)
        
        alertPage.addAction(okayAction)
        
        alertPage.show()
    }
    
    public func presentObservableOkayAlert(title: String?, message: String?) -> Observable<Void> {
        return Observable.create { o in
            let alertPage = AlertPage(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                o.onNext(())
                o.onCompleted()
            }
            
            alertPage.addAction(okayAction)
            
            alertPage.show()
            
            return Disposables.create { }
        }
    }
    
    public func presentObservableConfirmAlert(title: String?, message: String?, yesText: String = "Yes", noText: String = "No") -> Observable<Bool> {
        return Observable.create { o in
            let alertPage = AlertPage(title: title, message: message, preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: yesText, style: .cancel) { _ in
                o.onNext(true)
                o.onCompleted()
            }
            let noAction = UIAlertAction(title: noText, style: .default) { _ in
                o.onNext(false)
                o.onCompleted()
            }
            
            alertPage.addAction(yesAction)
            alertPage.addAction(noAction)
            
            alertPage.show()
            
            return Disposables.create { }
        }
    }
    
    public func presentObservaleActionSheet(title: String?, message: String?, actionTitles: [String] = ["OK"], cancelTitle: String = "Cancel") -> Observable<String> {
        return Observable.create { o in
            let alertPage = AlertPage(title: title, message: message, preferredStyle: .actionSheet)
            
            for title in actionTitles {
                let action = UIAlertAction(title: title, style: .default) { _ in
                    o.onNext(title)
                    o.onCompleted()
                }
                alertPage.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                o.onNext(cancelTitle)
                o.onCompleted()
            }
            alertPage.addAction(cancelAction)
            
            alertPage.show()
            
            return Disposables.create { }
        }
    }
    
}




















