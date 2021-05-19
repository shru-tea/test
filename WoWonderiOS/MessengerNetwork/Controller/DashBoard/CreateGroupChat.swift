//
//  CreateGroupChat.swift
//  WoWonderiOS
//
//  Created by Ubaid Javaid on 11/15/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import UIKit
import Async

class CreateGroupChat: BaseVC {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var selctImg: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var selectedUsersArray = [AddParticipantModel]()
    private var idsString:String? = ""
    private var idsArray = [Int]()
    private let imagePickerController = UIImagePickerController()
    private var imageData:Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
         self.navigationItem.largeTitleDisplayMode = .never
         let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
         navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.setupUI()
    }
    

        private func setupUI(){
            
            self.tableView.register(UINib(nibName: "GroupParticipentCell", bundle: nil), forCellReuseIdentifier: "GroupParticipantcell")
           self.tableView.register(UINib(nibName: "AddParticipantCell", bundle: nil), forCellReuseIdentifier: "addParticipentCell")
            self.tableView.tableFooterView = UIView()

            self.selctImg.setTitle(NSLocalizedString("Select Image", comment: "Select Image"), for: .normal)
            self.groupNameTextField.placeholder = NSLocalizedString("Group Name", comment: "Group Name")
            self.title = NSLocalizedString("Create Group", comment: "Create Group")
            let add = UIBarButtonItem(title: NSLocalizedString("Add", comment: "Add"), style: .done, target: self, action: Selector("Add"))
            self.navigationItem.rightBarButtonItem = add
            
        }
    
    
    @objc func Add(){
        if imageData == nil{
            self.view.makeToast(NSLocalizedString("Please select group avatar.", comment: "Please select group avatar."))
//            let securityAlertVC = R.storyboard.main.securityPopupVC()
//            securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
//            securityAlertVC?.errorText = NSLocalizedString("Please select group avatar.", comment: "Please select group avatar.")
//            self.present(securityAlertVC!, animated: true, completion: nil)
        }else if self.groupNameTextField.text!.isEmpty{
            
            self.view.makeToast(NSLocalizedString("Please enter group name.", comment: "Please enter group name."))

        }else if self.idsString == ""{
            
            self.view.makeToast(NSLocalizedString("Please select Atleast one participant.", comment: "Please select Atleast one participant."))

//            let securityAlertVC = R.storyboard.main.securityPopupVC()
//            securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
//            securityAlertVC?.errorText = NSLocalizedString("Please select Atleast one participant.", comment: "Please select Atleast one participant.")
//            self.present(securityAlertVC!, animated: true, completion: nil)
        }else{
            self.createGroup()
            
        }
    }
    
    
    @IBAction func selectImagePressed(_ sender: Any) {
        let alert = UIAlertController(title: "", message: NSLocalizedString("Select Source", comment: "Select Source"), preferredStyle: .alert)
         let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { (action) in
             self.imagePickerController.delegate = self
             
             self.imagePickerController.allowsEditing = true
             self.imagePickerController.sourceType = .camera
             self.present(self.imagePickerController, animated: true, completion: nil)
         }
         let gallery = UIAlertAction(title: NSLocalizedString("Gallery", comment: "Gallery"), style: .default) { (action) in
             self.imagePickerController.delegate = self
             
             self.imagePickerController.allowsEditing = true
             self.imagePickerController.sourceType = .photoLibrary
             self.present(self.imagePickerController, animated: true, completion: nil)
         }
         let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
         alert.addAction(camera)
         alert.addAction(gallery)
         alert.addAction(cancel)
         self.present(alert, animated: true, completion: nil)
    }
    
    
    private func createGroup(){
        self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
        let sessionToken = UserData.getAccess_Token() ?? ""
        let groupName  = self.groupNameTextField.text ?? ""
        let imageData = self.imageData ?? Data()
        print(imageData)
        let parts = self.idsString ?? ""
        Async.background({
            GroupChatManager.instance.createGroup(session_Token: sessionToken, groupName: groupName, parts: parts, type: "create", avatar_data: imageData, completionBlock: { (success, sessionError, serverError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.debug("success = \(success?.apiStatus ?? 0)")
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.error("sessionError = \(sessionError?.errors?.errorText)")
                            self.view.makeToast(sessionError?.errors?.errorText ?? "")
                        }
                        
                    })
                    
                    
                }else if serverError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            log.error("serverError = \(serverError?.errors?.errorText ?? "")")
                            self.view.makeToast(serverError?.errors?.errorText ?? "")
                        }
                        
                    })
                    
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            log.error("error = \(error?.localizedDescription)")
                            self.view.makeToast(error?.localizedDescription ?? "")
                        }
                        
                    })
                    
                }
            })
        
        })
        
        
    }
    
}


extension CreateGroupChat:participantsCollectionDelegate{
    func selectParticipantsCollection(idsString: String, participantsArray: [AddParticipantModel]) {
        self.selectedUsersArray = participantsArray
        self.idsString = idsString
        log.verbose("Self.idString = \(self.idsString)")
        log.verbose(".idString = \(idsString)")
        
        log.verbose("self.selectedUsersArray = \(self.selectedUsersArray)")
        self.tableView.reloadData()
//        self.collectionView.reloadData()
       
    }
}

extension CreateGroupChat: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return self.selectedUsersArray.count ?? 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "addParticipentCell") as! AddParticipantCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupParticipantcell") as! GroupParticipentCell
             let index = self.selectedUsersArray[indexPath.row]
             cell.userNameLabel.text = index.username
            cell.statusLabel.text = "Hi! there i am using Wowonder..."
            let url = URL.init(string:index.profileImage ?? "")
            cell.profileImage.sd_setImage(with: url , placeholderImage:R.image.ic_profileimage())
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let Storyboard = UIStoryboard(name: "Chat", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "AddParticipantsVC") as! AddParticipantsVC
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 0){
        return false
        }
        else{
        return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 1){
            if (editingStyle == UITableViewCell.EditingStyle.delete) {
                self.selectedUsersArray.remove(at: indexPath.row)
                self.tableView.reloadData()
                // handle delete (by removing the data from your array and updating the tableview)
            }
        }
    }
}

extension  CreateGroupChat:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.groupImage.image = image
        self.imageData = image.jpegData(compressionQuality: 0.1)
        self.dismiss(animated: true, completion: nil)
        
        
    }
}


//extension CreateGroupChat:participantsCollectionDelegate{
//    func selectParticipantsCollection(idsString: String, participantsArray: [AddParticipantModel]) {
//        self.selectedUsersArray = participantsArray
//        self.idsString = idsString
//        log.verbose("Self.idString = \(self.idsString)")
//        log.verbose(".idString = \(idsString)")
//
//        log.verbose("self.selectedUsersArray = \(self.selectedUsersArray)")
//        self.tableView.reloadData()
////        self.collectionView.reloadData()
//
//    }
//}
