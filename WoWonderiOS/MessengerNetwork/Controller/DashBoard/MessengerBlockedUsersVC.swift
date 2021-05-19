

import UIKit
import Async
import SwiftEventBus
import WoWonderTimelineSDK
//import GoogleMobileAds


class MessengerBlockedUsersVC: BaseVC {
    @IBOutlet weak var noBlockLabel: UILabel!
    @IBOutlet weak var downTextLabel: UILabel!
    @IBOutlet weak var showStack: UIStackView!
    @IBOutlet weak var blockeduserImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private var blockedUsersArray = [GetBlockedUsersModel.BlockedUser]()
    private  var refreshControl = UIRefreshControl()
    private var fetchSatus:Bool? = true
//    var bannerView: GADBannerView!
//    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
            self.fetchData()
            
            
        }
        
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            log.verbose("Internet dis connected!")
        }
        
    }
    deinit{
        SwiftEventBus.unregister(self)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setupUI(){
        self.noBlockLabel.text = NSLocalizedString("There is no blocked Users", comment: "")
        self.downTextLabel.text = NSLocalizedString("Start Blocking Users", comment: "")
        self.blockeduserImage.isHidden = true
        self.showStack.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.title = NSLocalizedString("Blocked Users", comment: "Blocked Users")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.tableView.separatorStyle = .none
        tableView.register( R.nib.blockedUsersTableCell(), forCellReuseIdentifier: R.reuseIdentifier.blockedUsers_TableCell.identifier)
//        if ControlSettings.shouldShowAddMobBanner{
//
//
//            interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//            let request = GADRequest()
//            interstitial.load(request)
//
//        }
    }
    @objc func refresh(sender:AnyObject) {
        fetchSatus = true
        self.blockedUsersArray.removeAll()
        self.tableView.reloadData()
        self.fetchData()
        
    }
//    func CreateAd() -> GADInterstitial {
//        let interstitial = GADInterstitial(adUnitID:  ControlSettings.interestialAddUnitId)
//        interstitial.load(GADRequest())
//        return interstitial
//    }
    private func fetchData(){
        if fetchSatus!{
            fetchSatus = false
            self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        }else{
            log.verbose("will not show Hud more...")
        }
        
        self.blockedUsersArray.removeAll()
        let sessionToken = UserData.getAccess_Token() ?? ""
        
        Async.background({
            BlockUsersManager.instanc.getBlockedUsers(session_Token: sessionToken, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("userList = \(success?.blockedUsers ?? nil)")
                            if (success?.blockedUsers?.isEmpty)!{
                                
                                self.blockeduserImage.isHidden = false
                                self.showStack.isHidden = false
                                self.refreshControl.endRefreshing()
                            }else {
                                self.blockeduserImage.isHidden = true
                                self.showStack.isHidden = true
                                self.blockedUsersArray = (success?.blockedUsers) ?? []
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                            
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.errors?.errorText)
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            
                        }
                    })
                }else if serverError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(serverError?.errors?.errorText)
                            log.error("serverError = \(serverError?.errors?.errorText)")
                        }
                        
                    })
                    
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription)
                            log.error("error = \(error?.localizedDescription)")
                        }
                    })
                }
                
            })
            
            
            
        })
        
    }
}
extension MessengerBlockedUsersVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blockedUsersArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.blockedUsers_TableCell.identifier) as? BlockedUsers_TableCell
        let object = blockedUsersArray[indexPath.row]
        cell?.usernameLabel.text = object.username ?? ""
        cell?.lastSeenLabel.text = "\(NSLocalizedString("Last seen", comment: "Last seen"))\(" ")\(object.lastseenTimeText ?? "")"
        let url = URL.init(string:object.avatar ?? "")
        cell?.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
        cell?.profileImage.cornerRadiusV = (cell?.profileImage.frame.height)! / 2
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if AppInstance.instance.addCount == ControlSettings.interestialCount {
//            if interstitial.isReady {
//                interstitial.present(fromRootViewController: self)
//                interstitial = CreateAd()
//                AppInstance.instance.addCount = 0
//            } else {
//                
//                print("Ad wasn't ready")
//            }
//        }
        AppInstance.instance.addCount =  AppInstance.instance.addCount! + 1
        let vc = R.storyboard.chat.blockedUsersPopupVC()
        let blockedUsersObject = blockedUsersArray[indexPath.row]
        vc?.blockedUserObject = blockedUsersObject
        self.present(vc!, animated: true, completion: nil)
    }
    
}
