//
//  CasadeFlowLayout.swift
//  TestPro
//
//  Created by yyg on 2017/8/31.
//  Copyright © 2017年 lzqok. All rights reserved.
//

import UIKit

class CasadeFlowLayout: UICollectionViewLayout {
    
    enum ScrollDirection {
        case horizontal
        case vertical
    }
    var columMaxXYs = [[CGFloat]]()
    var attrsArray = [[UICollectionViewLayoutAttributes]] ()
    var miniRow:CGFloat = 5
    var minColum:CGFloat = 5
    var sectionEdgeInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    var colums = [Int]()
    var list = [String]()
    var scrollDirection:ScrollDirection = .horizontal
    override var collectionViewContentSize:CGSize{
        var destMaxY = columMaxXYs[0][0]
        for i in 0..<columMaxXYs.count {
            for j in 0..<columMaxXYs[i].count {
                if destMaxY < columMaxXYs[i][j] {
                    destMaxY = columMaxXYs[i][j]
                }
            }
            
        }
        if scrollDirection == .vertical {
            return CGSize(width:0,height:destMaxY+sectionEdgeInset.bottom)
        }else {
            return CGSize(width:destMaxY+sectionEdgeInset.left,height:0)
        }
    }
    
    override func prepare() {
        super.prepare()
        self.columMaxXYs.removeAll()
        let sectionCount = self.collectionView!.numberOfSections
        
        for i in 0..<sectionCount {
            self.columMaxXYs.append([CGFloat]())
            attrsArray.append([UICollectionViewLayoutAttributes]())
            let indexPath = IndexPath.init(row: 0, section: i)
            //头部视图
            let layoutHeader = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
            layoutHeader.frame = CGRect.init(x: 0, y: 0, width: self.collectionView!.bounds.width, height: 50)
            
            attrsArray[i].append(layoutHeader)
            for _ in 0..<colums[i] {
                if scrollDirection == .vertical {
                    self.columMaxXYs[i].append(sectionEdgeInset.top)
                }else {
                    self.columMaxXYs[i].append(sectionEdgeInset.left)
                }
            }
        }
        
        for j in 0..<sectionCount{
            let count = self.collectionView!.numberOfItems(inSection: j)
            for i in 0..<count {
                let indexPath = IndexPath.init(item: i, section: j)
                let attributes = self.layoutAttributesForItem(at: indexPath)
                attrsArray[indexPath.section].append(attributes!)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let sectionCount = self.collectionView!.numberOfSections
        var attr = [UICollectionViewLayoutAttributes]()
        for i in 0..<sectionCount {
            attr.append(contentsOf: self.attrsArray[i])
        }
        return attr
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
        
        if scrollDirection == .vertical {
            let xMargin = sectionEdgeInset.left + sectionEdgeInset.right + CGFloat((colums[indexPath.section] - 1)) * minColum
            let cellWidth = (self.collectionView!.bounds.width - xMargin)/CGFloat(colums[indexPath.section])
            
            let h:CGFloat = 150 + getTextHeigh(textStr: list[indexPath.row], font: UIFont.systemFont(ofSize: 13), width: cellWidth-10)
            
            var destColum = 0
            var destMinY = columMaxXYs[indexPath.section][0]
            
            if indexPath.section > 0 {
                var maxXY:CGFloat = 0.0
                for i in 0..<columMaxXYs[indexPath.section-1].count {
                    if maxXY < columMaxXYs[indexPath.section-1][i] {
                        maxXY = columMaxXYs[indexPath.section-1][i]
                    }
                }
                
                for i in 0..<columMaxXYs[indexPath.section].count {
                    if destMinY > columMaxXYs[indexPath.section][i] {
                        destMinY = columMaxXYs[indexPath.section][i]
                        destColum = i
                    }
                }
                
                if  destMinY < 10 {
                    destMinY = maxXY
                }
                
            }else{
                for i in 1..<columMaxXYs[indexPath.section].count {
                    if destMinY > columMaxXYs[indexPath.section][i] {
                        destMinY = columMaxXYs[indexPath.section][i]
                        destColum = i
                    }
                }
                
            }
            
            let x = sectionEdgeInset.left + CGFloat(destColum) * (cellWidth+minColum)
            let y = destMinY + sectionEdgeInset.top
            attrs.frame = CGRect(x:x,y:y,width:cellWidth,height:h)
            
            self.columMaxXYs[indexPath.section][destColum] = attrs.frame.maxY
        }else{
            let yMargin = sectionEdgeInset.top + sectionEdgeInset.bottom + CGFloat((colums[indexPath.section] - 1)) * miniRow
            let cellHeight = (self.collectionView!.bounds.height - 64 - yMargin)/CGFloat(colums[indexPath.section])
            
            let w:CGFloat = 150 + getTextHeigh(textStr: list[indexPath.row], font: UIFont.systemFont(ofSize: 13), width: cellHeight-10)
            
            var destRow = 0
            var destMinX = columMaxXYs[indexPath.section][0]
            
            if indexPath.section > 0 {
                var maxXY:CGFloat = 0.0
                for i in 0..<columMaxXYs[indexPath.section-1].count {
                    if maxXY < columMaxXYs[indexPath.section-1][i] {
                        maxXY = columMaxXYs[indexPath.section-1][i]
                    }
                }
                
                for i in 0..<columMaxXYs[indexPath.section].count {
                    if destMinX > columMaxXYs[indexPath.section][i] {
                        destMinX = columMaxXYs[indexPath.section][i]
                        destRow = i
                    }
                }
                
                if  destMinX < 10 {
                    destMinX = maxXY
                }
                
            }else{
                
                for i in 1..<columMaxXYs[indexPath.section].count {
                    if destMinX > columMaxXYs[indexPath.section][i] {
                        destMinX = columMaxXYs[indexPath.section][i]
                        destRow = i
                    }
                }
            }
            let x = destMinX + sectionEdgeInset.left
            let y = sectionEdgeInset.top + CGFloat(destRow) * (cellHeight+miniRow)
            attrs.frame = CGRect(x:x,y:y,width:w,height:cellHeight)
            self.columMaxXYs[indexPath.section][destRow] = attrs.frame.maxX
            
        }
        
        return attrs
    }
}
