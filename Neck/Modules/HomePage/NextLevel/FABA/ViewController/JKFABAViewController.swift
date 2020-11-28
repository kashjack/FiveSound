//
//  JKFABAViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/11/23.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKFABAViewController: JKViewController {

    @IBOutlet weak var btnForBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setAction()

    }
    
    // MARK:  setAction
    private func setAction() {
        self.btnForBack.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
