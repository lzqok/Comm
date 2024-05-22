//
//  WaterFlowVC.swift
//  EmptyCommon_Example
//
//  Created by empty on 2024/5/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import ECommon
import MJRefresh

class WaterFlowVC: UIViewController,UICollectionViewDataSource,CasadeFlowLayoutDelegate,UICollectionViewDelegateFlowLayout {

    lazy var collectionView = {
        let flowLayout = CasadeFlowLayout()
        flowLayout.delegate = self
//        flowLayout.scrollDirection = .horizontal
        flowLayout.miniRow = 10
        flowLayout.minColum = 10
        flowLayout.sectionEdgeInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            collectionView.mj_header?.endRefreshing()
        })
        
        collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            collectionView.mj_footer?.endRefreshing()
        })
        
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    } ()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
//            collectionView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0)
//            collectionView.scrollIndicatorInsets = collectionView.contentInset
        }
        
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            header.backgroundColor = UIColor.systemPink
            var titleLabel = UILabel()
            titleLabel.tag = 100
            if let reusableLabel =  header.viewWithTag(100) as? UILabel {
                titleLabel = reusableLabel
            }
            titleLabel.text = "标题 \(indexPath.section)"
            header.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 5).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 5).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -5).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -5).isActive = true
            return header
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
            footer.backgroundColor = UIColor.systemPink
            var titleLabel = UILabel()
            titleLabel.tag = 100
            if let reusableLabel =  footer.viewWithTag(100) as? UILabel {
                titleLabel = reusableLabel
            }
            titleLabel.text = "底部 \(indexPath.section)"
            footer.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(equalTo: footer.topAnchor, constant: 5).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 5).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -5).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: footer.bottomAnchor, constant: -5).isActive = true
            return footer
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.blue
        
        
        var titleLabel = UILabel()
        titleLabel.tag = 100
        if let reusableLabel =  cell.viewWithTag(100) as? UILabel {
            titleLabel = reusableLabel
        }
        titleLabel.text = "row \(indexPath.row)"
        cell.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -5).isActive = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected",indexPath)
    }
    
    func casadeFlowLayoutColum(section: Int) -> Int {
        if section == 2 {
            return 3
        }
        return 2
    }
    
    func casadeFlowLayoutHeaderSize(indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 50
    }

    func casadeFlowLayoutSize(indexPath:IndexPath) -> CGFloat {
        let cellHeights:[CGFloat] = [50,30,100,23,156,231,50,30,100,23,156,231,50,30,100,23,156,231,50,30,100,23,156,231,50,30,100,23,156,231,50,30,100,23,156,231]
        return cellHeights[indexPath.row]
    }
    
    func casadeFlowLayoutFooterSize(indexPath: IndexPath) -> CGFloat {
        return 100
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
