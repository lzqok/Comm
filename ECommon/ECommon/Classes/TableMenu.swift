//
//  TableMenue.swift
//  DrinkChart
//
//  Created by lzqok on 2017/3/16.
//  Copyright © 2017年 lzqok. All rights reserved.
//

import UIKit
// 点击协议
public protocol TableMenuDelegate {
    func didSelectMenu(_ index:NSInteger)
}

@objcMembers
public class TableMenu: UIView,UITableViewDelegate,UITableViewDataSource {
    private let cellHeight:CGFloat = 44 //cell的高度
    private let tableWidth:CGFloat = 150 //tableView 的高度
    private let shapView:UIView = UIView() // 用于触摸消失的View
    private var titles = Array<String>() // 名称列表
    private var images = Array<String>() //图片列表
    private var tableView = UITableView()
    
    public var autoDissmiss = true
    
    public var fontColor : UIColor?{
        willSet {
            self.fontColor = newValue
            tableView.reloadData()
        }
    }
    // 列表文字大小
    public var fontSize : UIFont?{
        willSet {
            self.fontSize = newValue
            tableView.reloadData()
        }
    }
    
    public var delegate : TableMenuDelegate?
    
    public init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        setUpView()
    }
    
    public override init(frame:CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(){
        fontColor = UIColor.black
        fontSize = UIFont.systemFont(ofSize: 15)
        self.addSubview(shapView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.cornerRadius = 5
        self.tableView.separatorColor = UIColor.gray
        self.addSubview(self.tableView)
        
        shapView.translatesAutoresizingMaskIntoConstraints = false
        shapView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        shapView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        shapView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        shapView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
    }
    
    public func setInfo(titles:Array<String>,images:Array<String>){
        self.titles = titles
        self.images = images
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectMenu(indexPath.row)
        dissmiss()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let p:UIView =  ((touches as NSSet).anyObject() as AnyObject).view
        if p == shapView {
            dissmiss()
        }
    }

    public func showInView(_ point:CGPoint = .zero, view : UIView) {
        for menueView in view.subviews {
            if menueView.isKind(of: TableMenu.self){
                menueView.removeFromSuperview()
            }
        }
        view.addSubview(self)
    
        let height:CGFloat = CGFloat(titles.count) * cellHeight
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor,constant: point.y).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: point.x).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: view.heightAnchor, constant: height).isActive = true
        tableView.reloadData()
    }

    public func dissmiss() {
        if autoDissmiss {
            self.removeFromSuperview()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
