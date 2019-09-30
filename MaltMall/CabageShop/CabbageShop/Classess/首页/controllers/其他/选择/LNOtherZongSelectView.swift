//
//  LNOtherZongSelectView.swift
//  CabbageShop
//
//  Created by 吴伟助 on 2018/12/22.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
class LNOtherZongSelectView: UIView {

    let identyfierTable = "identyfierTable"
    var mainTableView = UITableView()
    //    数据源
    fileprivate var resource = ["综合","优惠券面值由高到低"/*,"佣金金额由高到低","佣金比例由低到高"*/,"上新"]
    fileprivate var selectIndex = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //    回调
    typealias swiftBlock = (_ message:NSInteger) -> Void
    var willClick : swiftBlock? = nil
    func callBackBlock(block: @escaping ( _ message:NSInteger) -> Void ) {
        willClick = block
    }

    func configSubViews() {

        mainTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: self.height), style: .plain)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.estimatedRowHeight = 100 * kSCREEN_SCALE
        mainTableView.tableFooterView = UIView()

        mainTableView.register(UINib(nibName: "LNOtherSelectCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        
        mainTableView.backgroundColor = kGaryColor(num: 255)
        mainTableView.separatorStyle = .none
        self.addSubview(mainTableView)
        weak var weakSelf = self
        mainTableView.snp.makeConstraints { (ls) in
            ls.right.left.top.equalToSuperview()
            ls.height.equalTo((weakSelf?.height)!)
        }
    }
    
}

extension LNOtherZongSelectView : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNOtherSelectCell
        cell.selectionStyle = .none
        var flag = false
        
        if indexPath.row == selectIndex {
            flag = true
        }
        cell.setValues(title: resource[indexPath.row], isSelect: flag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectIndex = indexPath.row
        
        if willClick != nil {
            willClick!(selectIndex)
        }
        tableView.reloadData()
    }
}
