//
//  ContactPage.swift
//  DDMvvm_Example
//
//  Created by Dao Duy Duong on 9/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import DDMvvm
import RxCocoa
import Alamofire
import Action

class ContactPage: Page<ContactPageViewModel> {

    let downloadBtn = UIButton()
    let speedLbl = UILabel()
        
    override func initialize() {
        enableBackButton = true
        
        downloadBtn.setTitle("Download", for: .normal)
        downloadBtn.setTitleColor(.red, for: .normal)
        downloadBtn.setBackgroundImage(UIImage.from(color: .blue), for: .normal)
        view.addSubview(downloadBtn)
        downloadBtn.autoAlignAxis(toSuperviewAxis: .vertical)
        downloadBtn.autoPinEdge(toSuperviewEdge: .top, withInset: 150)
        
        view.addSubview(speedLbl)
        speedLbl.autoPinEdge(.top, to: .bottom, of: downloadBtn, withOffset: 20)
        speedLbl.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    override func bindViewAndViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.speed.map { String(format: "%.2fMbps", $0) } ~> speedLbl.rx.text => disposeBag
        downloadBtn.rx.bind(to: viewModel.downloadAction, input: ())
    }
}

class ContactPageViewModel: ViewModel<Model> {
    
    let speed = BehaviorRelay<Double>(value: 0)
    
    lazy var downloadAction: Action<Void, Void> = {
        return Action() {
            self.doDownloading()
            return .just(())
        }
    }()
    
    private func doDownloading() {
        let kb: Double = 1024
        let mb: Double = kb * kb
        
        let startTime = Date().timeIntervalSince1970
        download("http://10.88.16.162/SPMobileAPI/api/NetworkApi/DownloadStream")
            .downloadProgress { (progress) in
                let received = Double(progress.completedUnitCount)
                let seconds = Date().timeIntervalSince1970 - startTime
                self.speed.accept((received/mb)*8/seconds)
                print("\(received) \(progress.fractionCompleted) \(self.speed.value)")
            }
            .responseString(completionHandler: { (response) in
                let total = Double(response.result.value?.count ?? 0)
                let seconds = Date().timeIntervalSince1970 - startTime
                let speed = (total/mb)*8/seconds
                print("download completed: \(speed)")
            })
    }
}
