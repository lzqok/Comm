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
    var columMaxXYs = [CGFloat]()
    var attrsArray = [UICollectionViewLayoutAttributes] ()
    var miniRow:CGFloat = 5
    var minColum:CGFloat = 5
    var sectionEdgeInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    var colum = 3
    var list = [String]()
    var scrollDirection:ScrollDirection = .horizontal
    override var collectionViewContentSize:CGSize{
        var destMaxY = columMaxXYs[0]
        for i in 0..<columMaxXYs.count {
            if destMaxY < columMaxXYs[i] {
                destMaxY = columMaxXYs[i]
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
        for _ in 0..<colum {
            if scrollDirection == .vertical {
                self.columMaxXYs.append(sectionEdgeInset.top)
            }else {
                self.columMaxXYs.append(sectionEdgeInset.left)
            }
        }
        
        let count = self.collectionView!.numberOfItems(inSection: 0)
        for i in 0..<count {
            let indexPath = IndexPath.init(item: i, section: 0)
            let attributes = self.layoutAttributesForItem(at: indexPath)
            attrsArray.append(attributes!)
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attrsArray
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)

        if scrollDirection == .vertical {
            let xMargin = sectionEdgeInset.left + sectionEdgeInset.right + CGFloat((colum - 1)) * minColum
            let cellWidth = (self.collectionView!.bounds.width - xMargin)/CGFloat(colum)
            
            let h:CGFloat = 150 + getTextHeigh(textStr: list[indexPath.row], font: UIFont.systemFont(ofSize: 13), width: cellWidth-10)
            
            var destColum = 0
            var destMinY = columMaxXYs[0]
            for i in 1..<columMaxXYs.count {
                if destMinY > columMaxXYs[i] {
                    destMinY = columMaxXYs[i]
                    destColum = i
                }
            }
            let x = sectionEdgeInset.left + CGFloat(destColum) * (cellWidth+minColum)
            let y = destMinY + sectionEdgeInset.top
            attrs.frame = CGRect(x:x,y:y,width:cellWidth,height:h)
            self.columMaxXYs[destColum] = attrs.frame.maxY
        }else{
            let yMargin = sectionEdgeInset.top + sectionEdgeInset.bottom + CGFloat((colum - 1)) * miniRow
            let cellHeight = (self.collectionView!.bounds.height - 64 - yMargin)/CGFloat(colum)
            
            let w:CGFloat = 150 + getTextHeigh(textStr: list[indexPath.row], font: UIFont.systemFont(ofSize: 13), width: cellHeight-10)
            
            var destRow = 0
            var destMinX = columMaxXYs[0]
            for i in 1..<columMaxXYs.count {
                if destMinX > columMaxXYs[i] {
                    destMinX = columMaxXYs[i]
                    destRow = i
                }
            }
            let x = destMinX + sectionEdgeInset.left
            let y = sectionEdgeInset.top + CGFloat(destRow) * (cellHeight+miniRow)
            attrs.frame = CGRect(x:x,y:y,width:w,height:cellHeight)
            self.columMaxXYs[destRow] = attrs.frame.maxX
        }
        
        return attrs
    }
}
