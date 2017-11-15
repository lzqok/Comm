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
    var columMaxXYs = [[CGFloat]]() //每列最大Y
    var cellHeights = [CGFloat]() //item高度集合
    var attrsArray = [[UICollectionViewLayoutAttributes]] ()
    var miniRow:CGFloat = 5 //item之间的行间距
    var minColum:CGFloat = 5 // item 之间的列间距
    var sectionEdgeInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    var colums = [2] //每个section 一行占多少列
    var startY:CGFloat = 0 // 开始Y
    var hearderHeight:CGFloat = 0 //头部view高度
    
    var scrollDirection:ScrollDirection = .horizontal //collectionView滚动方向
    
    private var tempAttrs = [[UICollectionViewLayoutAttributes]]()
    
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
        attrsArray.removeAll()
        startY = 0
        let sectionCount = self.collectionView!.numberOfSections
        for j in 0..<sectionCount{
            self.columMaxXYs.append([CGFloat]())
            attrsArray.append([UICollectionViewLayoutAttributes]())
            let count = self.collectionView!.numberOfItems(inSection: j)
            
            let indexPath = IndexPath.init(row: 0, section: j)
            //头部视图
            if hearderHeight > 0 {
                let layoutHeader = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
                
                attrsArray[j].append(layoutHeader)
                startY = sectionEdgeInset.top
                if j > 0 {
                    startY = attrsArray[j-1][attrsArray[j-1].count-1].frame.maxY + sectionEdgeInset.top
                }
                layoutHeader.frame = CGRect.init(x: 0, y: startY, width: self.collectionView!.bounds.width, height: hearderHeight)
                startY += hearderHeight
            }else {
                startY = sectionEdgeInset.top
            }
            
            for _ in 0..<colums[j] {
                if scrollDirection == .vertical {
                    self.columMaxXYs[j].append(startY)
                }else {
                    self.columMaxXYs[j].append(sectionEdgeInset.left)
                }
            }
            
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
            
            let h:CGFloat = cellHeights[indexPath.row]
            
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
            let y = destMinY + miniRow
            attrs.frame = CGRect(x:x,y:y,width:cellWidth,height:h)
            self.columMaxXYs[indexPath.section][destColum] = attrs.frame.maxY
        }else{
            let yMargin = sectionEdgeInset.top + sectionEdgeInset.bottom + CGFloat((colums[indexPath.section] - 1)) * miniRow
            let cellHeight = (self.collectionView!.bounds.height - 64 - yMargin)/CGFloat(colums[indexPath.section])
            
            let w:CGFloat = cellHeights[indexPath.row]
            
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
