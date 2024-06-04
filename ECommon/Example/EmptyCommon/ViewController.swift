//
//  ViewController.swift
//  EmptyCommon
//
//  Created by lzqok on 05/14/2024.
//  Copyright (c) 2024 lzqok. All rights reserved.
//

import UIKit
import ECommon
class ViewController: UIViewController, TableMenuDelegate {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableMenue = TableMenu()
        tableMenue.setInfo(titles: ["瀑布流","画廊","列表输入"], images: ["xxx.png","xxx.png","xxx.png"])
        tableMenue.autoDissmiss = false
        tableMenue.delegate = self
        tableMenue.showInView(view: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectMenu(_ index: NSInteger) {
        if index == 0 {
            let waterFlowVC = WaterFlowVC()
            waterFlowVC.modalPresentationStyle = .fullScreen
            self.present(waterFlowVC, animated: true)
        }else if index == 1 {
            let waterFlowVC = GalleryVC()
            waterFlowVC.modalPresentationStyle = .fullScreen
            self.present(waterFlowVC, animated: true)
        }else {
            let lineView = EYLineViewVC()
            self.present(lineView, animated: true)
        }
        
    }

}

