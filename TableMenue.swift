//
//  TableMenue.swift
//  DrinkChart
//
//  Created by lzqok on 2017/3/16.
//  Copyright © 2017年 lzqok. All rights reserved.
//

import UIKit
// 点击协议
protocol TableMenueDelegate {
    func didSelectMenue(_ index:NSInteger)
}

class TableMenue: UIView,UITableViewDelegate,UITableViewDataSource {
    private let cellHeight:CGFloat = 44 //cell的高度
    private let tableWidth:CGFloat = 150 //tableView 的高度
    private let shapView:UIView = UIView() // 用于触摸消失的View
    private var titles = Array<String>() // 名称列表
    private var images = Array<String>() //图片列表
    private var tableView = UITableView()
    var fontColor : UIColor?{
        willSet {
            self.fontColor = newValue
            tableView.reloadData()
        }
    }
    // 列表文字大小
    var fontSize : UIFont?{
        willSet {
            self.fontSize = newValue
            tableView.reloadData()
        }
    }
    
    var delegate : TableMenueDelegate?
    override init(frame:CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        setUpView(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(_ frame:CGRect){
        fontColor = UIColor.black
        fontSize = UIFont.systemFont(ofSize: 15)
        shapView.frame = frame
        self.addSubview(shapView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.cornerRadius = 5
        self.tableView.separatorColor = UIEdgeInsetsMake(0, 0, 0, 0)
        self.addSubview(self.tableView)

    }
    
    func setInfo(_ point:CGPoint,titles:Array<String>,images:Array<String>){
        self.titles = titles
        self.images = images
        let height:CGFloat = CGFloat(titles.count) * cellHeight
        
        self.tableView.frame = CGRect(x:point.x,y:point.y,width:tableWidth,height:height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = self.titles[indexPath.row]
        cell?.imageView?.image = UIImage.init(named: self.images[indexPath.row])
        cell?.textLabel?.textColor = fontColor
        cell?.textLabel?.font = fontSize
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectMenue(indexPath.row)
        dissmiss()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let p:UIView =  ((touches as NSSet).anyObject() as AnyObject).view
        if p == shapView {
            dissmiss()
        }
    }
    
    func showInView(_ view : UIView){
        for menueView in view.subviews {
            if menueView.isKind(of: TableMenue.self){
                menueView.removeFromSuperview()
            }
        }
        view.addSubview(self)
    }

    func dissmiss() {
        self.removeFromSuperview()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
