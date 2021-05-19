

import UIKit
protocol DidFilterDelegate {
    func filter(genderString:String, status:Int,distance:Int)
}
class FilterVC: UIViewController {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var statusAllBtn: UIButton!
    @IBOutlet weak var offlineBtn: UIButton!
    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var genderAllBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var applyFilterBtn: UIButton!
    private let color = UIColor.hexStringToUIColor(hex: "A84849")
    var genderString:String? = ""
    var status:Int? = 0
    var distance:Int? = 0
    var delegate:DidFilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    private func setupUI(){
        
        self.femaleBtn.setTitle(NSLocalizedString("FEMALE", comment: "FEMALE"), for: .normal)
        self.maleBtn.setTitle(NSLocalizedString("MALE", comment: "MALE"), for: .normal)
        self.genderAllBtn.setTitle(NSLocalizedString("All", comment: "All"), for: .normal)
        self.onlineBtn.setTitle(NSLocalizedString("ONLINE", comment: "ONLINE"), for: .normal)
        self.offlineBtn.setTitle(NSLocalizedString("OFFLINE", comment: "OFFLINE"), for: .normal)
        self.statusAllBtn.setTitle(NSLocalizedString("ALL", comment: "ALL"), for: .normal)
        self.resetBtn.setTitle(NSLocalizedString("Reset filter", comment: "Reset filter"), for: .normal)
        self.applyFilterBtn.setTitle(NSLocalizedString("Apply Filter", comment: "Apply Filter"), for: .normal)
        
        self.genderAllBtn.backgroundColor = color
        self.genderAllBtn.setTitleColor(.white, for: .normal)
        
        self.statusAllBtn.backgroundColor = color
        self.statusAllBtn.setTitleColor(.white, for: .normal)
        
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged(_:)), for: .valueChanged)
        
        self.genderString = "all"
        self.status = 2
        self.distance = 0
    }
    @objc func rangeSliderValueChanged(_ rangeSlider: UISlider) {
        
        self.distanceLabel.text = "\(Int(rangeSlider.value))km"
        self.distance = Int(rangeSlider.value)
    }
    
    @IBAction func genderAllPressed(_ sender: Any) {
        self.genderAllBtn.backgroundColor = color
        self.genderAllBtn.setTitleColor(.white, for: .normal)
        
        self.femaleBtn.backgroundColor = .clear
        self.femaleBtn.setTitleColor(.black, for: .normal)
        
        self.maleBtn.backgroundColor = .clear
        self.maleBtn.setTitleColor(.black, for: .normal)
        self.genderString = "all"
    }
    @IBAction func femalePressed(_ sender: Any) {
        self.femaleBtn.backgroundColor = color
        self.femaleBtn.setTitleColor(.white, for: .normal)
        
        self.genderAllBtn.backgroundColor = .clear
        self.genderAllBtn.setTitleColor(.black, for: .normal)
        
        self.maleBtn.backgroundColor = .clear
        self.maleBtn.setTitleColor(.black, for: .normal)
         self.genderString = "female"
    }
    
    
    @IBAction func malePressed(_ sender: Any) {
        self.maleBtn.backgroundColor = color
        self.maleBtn.setTitleColor(.white, for: .normal)
        
        self.genderAllBtn.backgroundColor = .clear
        self.genderAllBtn.setTitleColor(.black, for: .normal)
        
        self.femaleBtn.backgroundColor = .clear
        self.femaleBtn.setTitleColor(.black, for: .normal)
         self.genderString = "male"
    }
    
    @IBAction func onlinePressed(_ sender: Any) {
        self.onlineBtn.backgroundColor = color
        self.onlineBtn.setTitleColor(.white, for: .normal)
        
        self.offlineBtn.backgroundColor = .clear
        self.offlineBtn.setTitleColor(.black, for: .normal)
        
        self.statusAllBtn.backgroundColor = .clear
        self.statusAllBtn.setTitleColor(.black, for: .normal)
        self.status = 1
    }
    
    @IBAction func offlinePressed(_ sender: Any) {
        self.offlineBtn.backgroundColor = color
        self.offlineBtn.setTitleColor(.white, for: .normal)
        
        self.onlineBtn.backgroundColor = .clear
        self.onlineBtn.setTitleColor(.black, for: .normal)
        
        self.statusAllBtn.backgroundColor = .clear
        self.statusAllBtn.setTitleColor(.black, for: .normal)
         self.status = 0
    }
    @IBAction func statusAllPRessed(_ sender: Any) {
        self.statusAllBtn.backgroundColor = color
        self.statusAllBtn.setTitleColor(.white, for: .normal)
        
        self.onlineBtn.backgroundColor = .clear
        self.onlineBtn.setTitleColor(.black, for: .normal)
        
        self.offlineBtn.backgroundColor = .clear
        self.offlineBtn.setTitleColor(.black, for: .normal)
        self.status = 2
    }
    @IBAction func applyfilterPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.filter(genderString: self.genderString ?? "", status: self.status ?? 0, distance: self.distance ?? 0)
        }
    }
    @IBAction func resetFilterPressed(_ sender: Any) {
        self.genderAllBtn.backgroundColor = color
        self.genderAllBtn.setTitleColor(.white, for: .normal)
        
        self.maleBtn.backgroundColor = .clear
        self.maleBtn.setTitleColor(.black, for: .normal)
        
        self.femaleBtn.backgroundColor = .clear
        self.femaleBtn.setTitleColor(.black, for: .normal)
        
        self.statusAllBtn.backgroundColor = color
        self.statusAllBtn.setTitleColor(.white, for: .normal)
        
        self.onlineBtn.backgroundColor = .clear
              self.onlineBtn.setTitleColor(.black, for: .normal)
        
        self.offlineBtn.backgroundColor = .clear
              self.offlineBtn.setTitleColor(.black, for: .normal)
        
        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged(_:)), for: .valueChanged)
        
        self.genderString = "all"
        self.status = 2
        self.distance = 0
        self.rangeSlider.setValue(0, animated: true)
        self.distanceLabel.text = "\(Int(self.rangeSlider.value))"
    }
    
}

