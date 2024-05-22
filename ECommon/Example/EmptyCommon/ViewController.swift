//
//  ViewController.swift
//  EmptyCommon
//
//  Created by lzqok on 05/14/2024.
//  Copyright (c) 2024 lzqok. All rights reserved.
//

import UIKit
import EmptyCommon
class ViewController: UIViewController, TableMenuDelegate {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableMenue = TableMenu()
        tableMenue.setInfo(titles: ["瀑布流"], images: ["xxx.png"])
        tableMenue.autoDissmiss = false
        tableMenue.delegate = self
        tableMenue.showInView(view: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectMenu(_ index: NSInteger) {
        let waterFlowVC = WaterFlowVC()
        waterFlowVC.modalPresentationStyle = .fullScreen
        self.present(waterFlowVC, animated: true)
    }

}

