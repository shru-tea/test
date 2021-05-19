//
//  GroupRequestVC.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 8/18/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftEventBus
import WoWonderTimelineSDK
import Async
import ZKProgressHUD
class GroupRequestVC: BaseVC {
    
    @IBOutlet weak var noGrouplabel: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noRequestImage: UIImageView!
    private  var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var noRequestLabel: UILabel!
    var groupsArray = [GroupRequestModel.GroupChatRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI(){
        self.title = NSLocalizedString("Group Request", comment: "Group Request")
        self.noRequestLabel.text = NSLocalizedString("", comment: "")
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.requestGroupOneTableCell(), forCellReuseIdentifier: R.reuseIdentifier.requestGroupOne_TableCell.identifier)
        if self.groupsArray.isEmpty{
            self.tableView.isHidden = true
            self.noGrouplabel.isHidden = false
            self.noRequestImage.isHidden = false
        }else{
            self.tableView.isHidden = false
            self.noGrouplabel.isHidden = true
            self.noRequestImage.isHidden = true
        }
        
    }
    @objc func refresh(sender:AnyObject) {
        self.groupsArray.removeAll()
        self.tableView.reloadData()
    }
}
extension GroupRequestVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.groupsArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.requestGroupOne_TableCell.identifier) as? RequestGroupOne_TableCell
        cell?.vc = self
        let object = self.groupsArray[indexPath.row]
        cell?.groupID = self.groupsArray[indexPath.row].groupID ?? 0
        cell?.groupNameLabel.text = object.groupTab?.groupName ?? ""
        let url = URL.init(string:object.groupTab?.avatar ?? "")
        cell?.groupImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

