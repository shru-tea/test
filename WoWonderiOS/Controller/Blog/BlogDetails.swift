

import UIKit
import Kingfisher
import WoWonderTimelineSDK
import WebKit

class BlogDetails: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var copyLink: UIButton!
    @IBOutlet weak var shareLink: UIButton!
    @IBOutlet weak var profileImage: Roundimage!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var postDay: UILabel!
    var selectedIndex = 0
    
    var blogDetails = [[String:Any]]()
    var blogsComments = [[String:Any]]()
    var selectedIndexs = [[String:Any]]()
    
    
    var link = ""
    var blog_id: String? = nil
    var contentHeights : [CGFloat] = [1000.0]
    var webcontentHeight : CGFloat = 400.0
    
    let status = Reach().connectionStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "ArticleDetailCell", bundle: nil), forCellReuseIdentifier: "ArticleDetails")
        self.tableView.register(UINib(nibName: "AddCommentCell", bundle: nil), forCellReuseIdentifier: "AddBlogComment")
     self.tableView.register(UINib(nibName: "CommentCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        self.tableView.separatorStyle = .none
        for i in self.blogDetails{
            if let author = i["author"] as? [String:Any]{
                if let name = author["name"] as? String{
                    self.profileName.text = name
                }
                if let image = author["avatar"] as? String{
                    let url = URL(string: image)
                    self.profileImage.kf.setImage(with: url)
                }
            }
            
            if let link = i["url"] as? String{
                self.link = link
            }
            
            if let posted = i["posted"] as? String{
                self.postDay.text! = posted
            }
            if let blogId = i["id"] as? String{
                self.blog_id = blogId
            }
        }
        self.tableView.reloadData()
        self.getBlogComments(blogId: self.blog_id ?? "")
    }
    
    ///Network Connectivity.
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
        }
    }
    private func getBlogComments(blogId: String){
        switch status {
        case .unknown, .offline:
            self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
        case .online(.wwan),.online(.wiFi):
            performUIUpdatesOnMain {
                GetBlogCommentsManager.sharedInstance.getBlogComments(blogId: blogId) { (success, authError, error) in
                    if success != nil{
                        for i in success!.data{
                            self.blogsComments.append(i)
                        }
                        self.tableView.reloadData()
                    }
                    else if authError != nil{
                        self.view.makeToast(authError?.errors.errorText)
                    }
                    else{
                        self.view.makeToast(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func createComments(text: String){
        CreateBlogCommentsManager.sharedInstance.createBlogComment(blogId: self.blog_id ?? "", text: text) { (success, authError, error) in
            if success != nil{
                for i in success!.data{
                    self.blogsComments.append(i)
                }
                self.tableView.reloadData()
            }
            else if authError != nil{
                self.view.makeToast(authError?.errors.errorText)
            }
            else{
                self.view.makeToast(error?.localizedDescription)
            }
        }
    }
    
    private func likeComment(commentId: String,reaction_type: String){
        LikeBlogCommentManager.sharedInstance.likeComment(type: "like", comment_id: commentId, blogId: self.blog_id ?? "", reactionType: reaction_type) { (success, authError, error) in
            if success != nil{
                print(success?.type)
            }
            else if authError != nil{
                self.view.makeToast(authError?.errors.errorText)
            }
            else if error != nil{
                self.view.makeToast(error?.localizedDescription)
            }
        }
    }
    
    
    @IBAction func Back(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    
    @IBAction func CopyLink(_ sender: Any) {
        UIPasteboard.general.string = self.link
        self.view.makeToast(NSLocalizedString("Copied", comment: "Copied"))
    }
    
    @IBAction func ShareLink(_ sender: Any) {
        let text = self.link
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
//    @IBAction func NormalTapped(gesture: UIGestureRecognizer){
//        let status = Reach().connectionStatus()
//        switch status {
//        case .unknown, .offline:
//            self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
//        case .online(.wwan), .online(.wiFi):
//            let cell = self.tableView.cellForRow(at: IndexPath(row: gesture.view?.tag ?? 0, section: 0)) as! CommentCellTableViewCell
//            if let reactions = self.blogsComments[gesture.view?.tag ?? 0]["reaction"] as? [String:Any]{
//                var totalCount = 0
//                if let count = reactions["count"] as? Int{
//                    totalCount = count
//                }
//                if let isReacted = reactions["is_reacted"] as? Bool{
//                    if (isReacted == true){
//                        self.reactions(index: gesture.view?.tag ?? 0, reaction: "")
//                        var localPostArray = self.blogsComments[gesture.view?.tag ?? 0]["reaction"] as! [String:Any]
//                        localPostArray["is_reacted"] = false
//                        localPostArray["type"]  = ""
//                        localPostArray["count"] = totalCount - 1
//                        totalCount =  localPostArray["count"] as? Int ?? 0
//                        if totalCount == 0{
//                            cell.reactionImage.image = nil
//                            cell.reactionCount.text = nil
//                        }
//                        if let reaction_type = reactions["type"] as? String{
//                            if reaction_type == "1"{
//                                if let likecount = reactions["1"] as? Int{
//                                    localPostArray["1"] = likecount - 1
//                                }
//                            }
//                            else if reaction_type == "2"{
//                                if let lovecount = reactions["2"] as? Int{
//                                    localPostArray["2"] = lovecount - 1
//                                }
//                            }
//                            else if reaction_type == "3"{
//                                if let hahacount = reactions["3"] as? Int{
//                                    localPostArray["3"] = hahacount - 1
//                                }
//                            }
//                            else if reaction_type == "4"{
//                                if let wowcount = reactions["4"] as? Int{
//                                    localPostArray["4"] = wowcount - 1
//                                }
//                            }
//                            else if reaction_type == "5"{
//                                if let sadcount = reactions["5"] as? Int{
//                                    localPostArray["5"] = sadcount - 1
//                                }
//                            }
//                            else if reaction_type == "6"{
//                                if let angryCount = reactions["6"] as? Int{
//                                    localPostArray["6"] = angryCount - 1
//                                }
//                            }
//
//                        }
//                        self.blogsComments[gesture.view?.tag ?? 0]["reaction"] = localPostArray
//                        cell.likeBtn.setTitle(NSLocalizedString("Like", comment: "Like"), for: .normal)
//                        cell.likeBtn.setTitleColor(.black, for: .normal)
//                        cell.reactionCount.text = "\(totalCount)"
//                        if totalCount != 0{
//                        if let reacts = self.blogsComments[gesture.view?.tag ?? 0]["reaction"] as? [String:Any]{
//                            if let checkLike = reacts["1"] as? Int{
//                                if checkLike != 0{
//                                    cell.reactionImage.image = UIImage(named: "like-2")
//                                    break;
//                                }
//                            }
//                            if let checkLove = reacts["2"] as? Int{
//                                if checkLove != 0{
//                                    cell.reactionImage.image = UIImage(named: "love")
//                                    break;
//                                }
//                            }
//                            if let checkHaha = reacts["3"] as? Int{
//                                if checkHaha != 0{
//                                    cell.reactionImage.image = UIImage(named: "haha")
//                                    break;
//                                }
//                            }
//                            if let checkWow = reacts["4"] as? Int{
//                                if checkWow != 0{
//                                    cell.reactionImage.image = UIImage(named: "wow")
//                                    break;
//                                }
//
//                            }
//                            if let checkSad = reacts["5"] as? Int{
//                                if checkSad != 0{
//                                    cell.reactionImage.image = UIImage(named: "sad")
//                                    break;
//                                }
//                            }
//                            if let checkSad = reacts["6"] as? Int{
//                                if checkSad != 0{
//                                    cell.reactionImage.image = UIImage(named: "angry")
//                                    break;
//                                }
//                            }
//                        }
//                      }
//                        else{
//                            cell.reactionImage.image = nil
//                            cell.reactionCount.text = nil
//                        }
//                    }
//                    else{
//                        self.selectedIndex = gesture.view!.tag
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "LikeReactionsVC") as! LikeReactionsController
//                        vc.delegate = self
//                        vc.modalPresentationStyle = .overFullScreen
//                        vc.modalTransitionStyle = .crossDissolve
//                        self.present(vc, animated: true, completion: nil)
//                    }
//                }
//            }
//        }
//    }
    
    
    @IBAction func LongTapped(gesture: UILongPressGestureRecognizer){
        self.selectedIndex = gesture.view!.tag
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LikeReactionsVC") as! LikeReactionsController
//        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func addReaction(reation: String) {
        print(reation)
        let cell = self.tableView.cellForRow(at: IndexPath(row: self.selectedIndex ?? 0, section: 0)) as! CommentCellTableViewCell
        print(self.selectedIndex)
//        self.reactions(index: self.selectedIndex, reaction: reation)
        var localPostArray = self.blogsComments[self.selectedIndex]["reaction"] as! [String:Any]
        var totalCount = 0
        if let reactions = self.blogsComments[self.selectedIndex]["reaction"] as? [String:Any]{
            if let is_react = reactions["is_reacted"] as? Bool{
                if !is_react {
                    if let count = reactions["count"] as? Int{
                        totalCount = count
                    }
                    localPostArray["count"] = totalCount + 1
                    totalCount =  localPostArray["count"] as? Int ?? 0
                    print(totalCount)
                    cell.reactionCount.text = "\(totalCount)"
                }
                else{
                    if let count = reactions["count"] as? Int{
                        totalCount = count
                    }
                }
            }
        }
        let action = ["count": totalCount, "reaction": reation,"index": self.selectedIndex] as [String : Any]
        var count = 0
        print(self.selectedIndexs.count)
        if self.selectedIndexs.count == 0 {
            self.selectedIndexs.append(action)
        }
        else{
            for i in self.selectedIndexs{
                count += 1
                if i["index"] as? Int == self.selectedIndex{
                    print((count) - 1)
                    self.selectedIndexs[(count) - 1] = action
                }
                else{
                    self.selectedIndexs.append(action)
                }
            }
        }
        
        localPostArray["is_reacted"] = true
        localPostArray["type"]  = reation
        
        if reation == "1"{
            localPostArray["Like"] = 1
            localPostArray["1"] = 1
            self.blogsComments[self.selectedIndex]["reaction"] = localPostArray
            cell.reactionImage.image = UIImage(named: "like-2")
            cell.likeBtn.setTitle("\(NSLocalizedString("Like", comment: "Like"))", for: .normal)
            cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "3D5898"), for: .normal)
        }
        else if reation == "2"{
            localPostArray["Love"] = 1
            localPostArray["2"] = 1
            self.blogsComments[self.selectedIndex]["reaction"] = localPostArray
            cell.likeBtn.setTitle("\(NSLocalizedString("Love", comment: "Love"))", for: .normal)
            cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FB1002"), for: .normal)
            cell.reactionImage.image = UIImage(named: "love")
        }
        else if reation == "3"{
            localPostArray["HaHa"] = 1
            localPostArray["3"] = 1
            self.blogsComments[self.selectedIndex]["reaction"] = localPostArray
            cell.reactionImage.image = UIImage(named: "haha")
            cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            cell.likeBtn.setTitle("\(NSLocalizedString("Haha", comment: "Haha"))", for: .normal)
        }
        else if reation == "4"{
            localPostArray["Wow"] = 1
            localPostArray["4"] = 1
            self.blogsComments[self.selectedIndex]["reaction"] = localPostArray
            cell.reactionImage.image = UIImage(named: "wow")
            cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            cell.likeBtn.setTitle("\(NSLocalizedString("Wow", comment: "Wow"))", for: .normal)
        }
        else if reation == "5"{
            localPostArray["Sad"] = 1
            localPostArray["5"] = 1
            self.blogsComments[self.selectedIndex]["reaction"] = localPostArray
            cell.reactionImage.image = UIImage(named: "sad")
            cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FECD30"), for: .normal)
            cell.likeBtn.setTitle("\(NSLocalizedString("Sad", comment: "Sad"))", for: .normal)
        }
        else {
            localPostArray["Angry"] = 1
            localPostArray["6"] = 1
            self.blogsComments[self.selectedIndex]["reaction"] = localPostArray
            cell.reactionImage.image = UIImage(named: "angry")
            cell.likeBtn.setTitle("\(NSLocalizedString("Angry", comment: "Angry"))", for: .normal)
            cell.likeBtn.setTitleColor(.red, for: .normal)
        }
        
    }
    
    
    
//    private func reactions(index :Int, reaction: String) {
//        let status = Reach().connectionStatus()
//        switch status {
//        case .unknown, .offline:
//            self.tableView.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
//        case .online(.wwan), .online(.wiFi):
//            performUIUpdatesOnMain {
//                var comment_id = ""
//                if let commentId = self.comments[index]["id"] as? String{
//                    comment_id = commentId
//                }
//                AddCommentReactionManager.sharedInstacne.AddComment(commentId: Int(comment_id) ?? 0, reaction: reaction) { (success, authError, error) in
//                    if (success != nil){
//                        print(success?.message)
//                    }
//                    else if (authError != nil){
//                        print(authError?.errors?.errorText)
//                    }
//                    else if (error != nil){
//                        print(error?.localizedDescription)
//                    }
//                }
//
//            }
//        }
//    }
    
}

extension BlogDetails : UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 1
        }
        else if (section == 1) {
            if (self.blogsComments.count == 0 || self.blogsComments.isEmpty == true){
                return 1
            }
            else{
            return self.blogsComments.count
            }
        }
        else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleDetails") as! ArticleDetailCell
            let index = self.blogDetails[indexPath.row]
            
            if let title = index["title"] as? String{
                let attributeString = title.htmlToString
                let str = attributeString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

//                let atrribString = str
//                let font = UIFont.systemFont(ofSize: self.fonSize)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.firstLineHeadIndent = 0.0
                paragraphStyle.lineBreakMode = .byWordWrapping
                paragraphStyle.lineHeightMultiple = 1.5
                paragraphStyle.paragraphSpacingBefore = 10
                paragraphStyle.paragraphSpacing = 10
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: paragraphStyle
                ]
                
                let attributedString = NSAttributedString(string: attributeString, attributes: attributes)
                
                let attributed = NSMutableAttributedString(attributedString: attributedString)
                cell.blogTitle.attributedText = attributed
            }
            if let image = index["thumbnail"] as? String{
                let url = URL(string: image)
                cell.blogImage.kf.setImage(with: url)
            }
            if let content = index["content"] as? String{
                let attributeString = content.htmlToString
                let str = attributeString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                let changeHtml = attributeString.htmlToString
                print(changeHtml)
//                let atrribString = str
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.firstLineHeadIndent = 0.0
                paragraphStyle.lineBreakMode = .byWordWrapping
                paragraphStyle.lineHeightMultiple = 1.5
                paragraphStyle.paragraphSpacingBefore = 10
                paragraphStyle.paragraphSpacing = 10
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: paragraphStyle
                ]
                
                let attributedString = NSAttributedString(string: changeHtml, attributes: attributes)
                
                let attributed = NSMutableAttributedString(attributedString: attributedString)
                cell.blogDescription.attributedText = attributed
            }
         
            return cell
        }
        else if (indexPath.section == 1) {
            
            if self.blogsComments.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as! CommentCellTableViewCell
                cell.noCommentView.isHidden = true
                return cell
            }
            else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as! CommentCellTableViewCell
           let index = self.blogsComments[indexPath.row]
          cell.noCommentView.isHidden = false
          cell.imageHeight.constant = 0.0
          cell.imageWidth.isActive = false
          //        cell.imageWidth.constant = 100.0
          if let publisher = index["user_data"] as? [String:Any]{
              if let name = publisher["username"] as? String{
                  cell.userName.text = name
              }
              
              if let image = publisher["avatar"] as? String{
                  let url = URL(string: image)
                  cell.profileImage.kf.setImage(with: url)
              }
          }
            
          if let text = index["text"] as? String{
              cell.commentText?.text = text.htmlToString
          }
            if let replies = index["replies"] as? [[String:Any]]{
                
                if replies.isEmpty == true{
                  cell.replyBtn.setTitle("\("Reply")", for: .normal)
              }
              else {
                    cell.replyBtn.setTitle("\("Reply ")\("(\(replies.count))")", for: .normal)
              }
          }
          if let isLiked = index["is_comment_liked"] as? Bool{
              if isLiked{
                  cell.likeBtn.setTitle("Liked", for: .normal)
                  cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "#984243"), for: .normal)
              }
          }
          cell.reactionBtn.isHidden = true
          cell.reactionImage.isHidden = true
          cell.reactionCount.isHidden = true
          cell.replyBtn.tag = indexPath.row
          cell.likeBtn.tag = indexPath.row
          cell.replyBtn.addTarget(self, action: #selector(self.GotoCommentReply(sender:)), for: .touchUpInside)
          cell.likeBtn.addTarget(self, action: #selector(self.LikeComment(sender:)), for: .touchUpInside)
          cell.viewLeadingContraint.constant = 8.0
          return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddBlogComment") as! AddCommentCell
            cell.sendBtn.tag = indexPath.row
            cell.sendBtn.addTarget(self, action: #selector(self.send(sender:)), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UITableView.automaticDimension
        }
        else if (indexPath.section == 1) {
            if self.blogsComments.count == 0{
                return 230.0
            }
            else{
            return UITableView.automaticDimension
            }
        }
        else{
            return 55.0
        }
    }
    
    @IBAction func LikeComment(sender:UIButton){
        switch status {
         case .unknown, .offline:
             self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
         case .online(.wwan),.online(.wiFi):
            let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 1)) as! CommentCellTableViewCell
            var commentId :String? = nil
            if let id = self.blogsComments[sender.tag]["id"] as? String{
                commentId = id
            }
            if let isLiked = self.blogsComments[sender.tag]["is_comment_liked"] as? Bool{
                if isLiked{
                    cell.likeBtn.setTitle("Like", for: .normal)
                    cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "#333333"), for: .normal)
                    self.likeComment(commentId: commentId ?? "", reaction_type: "dislike")
                    self.blogsComments[sender.tag]["is_comment_liked"] = false
                }
                else {
                    cell.likeBtn.setTitle("Liked", for: .normal)
                    cell.likeBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "#984243"), for: .normal)
                    self.likeComment(commentId: commentId ?? "", reaction_type: "like")
                    self.blogsComments[sender.tag]["is_comment_liked"] = true
                }
            }
            
        }
    }
     
    @IBAction func GotoCommentReply(sender: UIButton){
        let Storyboard = UIStoryboard(name: "Poke-MyVideos-Albums", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier : "BlogCommentReplyVC") as! BlogCommentReplyController
        var commentId :String? = nil
        if let id = self.blogsComments[sender.tag]["id"] as? String{
            commentId = id
        }
        vc.comment = self.blogsComments[sender.tag]
        vc.blod_id = self.blog_id
        vc.commentId = commentId
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func send(sender:UIButton){
        switch status {
         case .unknown, .offline:
             self.view.makeToast(NSLocalizedString("Internet Connection Failed", comment: "Internet Connection Failed"))
         case .online(.wwan),.online(.wiFi):
             performUIUpdatesOnMain {
        let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as! AddCommentCell
                print(cell.textView.text)
                self.createComments(text: cell.textView.text)
                cell.textView.text = ""
                cell.sendBtn.isEnabled = false
                cell.sendBtn.setImage(#imageLiteral(resourceName: "right-arrow"), for: .normal)
                cell.textView.resignFirstResponder()
            }
        }
    }
    
}
