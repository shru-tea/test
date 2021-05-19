//
//  DashBoardParentVC.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 8/12/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DropDown
import WoWonderTimelineSDK
class DashBoardParentVC: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var nearByBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    private let moreDropdown = DropDown()
    override func viewDidLoad() {
        self.setupUI()
        super.viewDidLoad()
        self.customizeDropdown()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }
    @IBAction func nearByPressed(_ sender: Any) {
        AppInstance.instance.addCount =  AppInstance.instance.addCount! + 1

//        let vc = R.storyboard.chat.findFriendsVC()
//        self.navigationController?.pushViewController(vc!, animated: true)
        let storyboard = UIStoryboard(name: "MoreSection", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FindFriendVC") as! FindFriendVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func morePressed(_ sender: Any) {
        AppInstance.instance.addCount =  AppInstance.instance.addCount! + 1

        self.moreDropdown.show()
    }
    @IBAction func searchPressed(_ sender: Any) {
        AppInstance.instance.addCount =  AppInstance.instance.addCount! + 1
//
//        let vc = R.storyboard.chat.searchRandomVC()
//        vc?.statusIndex = 0
//        self.navigationController?.pushViewController(vc!, animated: true)
        let Storyboard = UIStoryboard(name: "Search", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "SearchVC") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    func customizeDropdown(){
        moreDropdown.dataSource = [NSLocalizedString("Block User List", comment: "Block User List")]
        moreDropdown.backgroundColor = UIColor.hexStringToUIColor(hex: "454345")
        moreDropdown.textColor = UIColor.white
        moreDropdown.anchorView = self.moreBtn
//        moreDropdown.bottomOffset = CGPoint(x: 312, y:-270)
        moreDropdown.width = 200
        moreDropdown.direction = .any
        moreDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                let storyboard = UIStoryboard(name: "General", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BlockedUsersVC") as! BlockedUsersVC
                self.navigationController?.pushViewController(vc, animated: true)
//                let vc = R.storyboard.chat.messengerBlockedUsersVC()
//                self.navigationController?.pushViewController(vc!, animated: true)
            }else{
//              let vc = R.storyboard.settings.settingsVC()
//                self.navigationController?.pushViewController(vc!, animated: true)
            }
            print("Index = \(index)")
        }
        
    }

    private func setupUI() {
        self.view.backgroundColor = .mainColor
        self.searchBtn.tintColor = .ButtonColor
        self.nearByBtn.tintColor = .ButtonColor
        self.moreBtn.tintColor = .ButtonColor
        self.nameLabel.textColor = .mainColor
        self.navigationController?.navigationBar.barTintColor = .mainColor
        self.appDelegate?.window?.tintColor = .mainColor
        
        self.containerView.isScrollEnabled = false
       self.nameLabel.text = NSLocalizedString("WoWonder Messenger", comment: "WoWonder Messenger")
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .mainColor
        settings.style.buttonBarItemFont =  UIFont.systemFont(ofSize: 15)
        settings.style.selectedBarHeight = 1
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
//        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        let color = UIColor.systemGray
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = color
            newCell?.label.textColor = .mainColor
            print("OldCell",oldCell)
            print("NewCell",newCell)
            
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        
        let chatVC = R.storyboard.chat.chatVC()
        let callVC = R.storyboard.chat.callsVC()
        let ChatGroupVC = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatGroupvc")

        return [chatVC!,ChatGroupVC,callVC!]
        
    }
    


}
