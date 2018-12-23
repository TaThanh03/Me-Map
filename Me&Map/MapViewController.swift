import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    private let mapMode = UISegmentedControl(items: ["Map", "Satellite", "Mix"])
    private let map = MKMapView()
    private let textField = UITextField()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        //TabBar
        let earthImage = UIImage(named: "Earth")
        let tbi = UITabBarItem(title: "Map", image: earthImage, tag: 1)
        self.tabBarItem = tbi
        self.title = "Map" //used by the navigation controller
        
        //SegmentedControl
        mapMode.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        mapMode.selectedSegmentIndex = 0
        mapMode.addTarget(self, action: #selector(changeMap(sender:)), for: .valueChanged)
        
        //MapView
        map.isScrollEnabled = true
        map.isZoomEnabled = true
        map.delegate = self
        
        //TextField
        textField.backgroundColor = UIColor.white
        textField.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.yellow
        
        //actions
        
        //addsubview
        self.view.addSubview(textField)
        self.view.addSubview(map)
        self.view.addSubview(mapMode)
        
        
        self.displayInSize(size: UIScreen.main.bounds.size)
    }
    
    
    func displayInSize(size: CGSize) {
        let top = 70
        textField.frame = CGRect(x: 0, y: top, width: Int(size.width), height: 30)
        map.frame = CGRect(x: 0, y: top + 35, width: Int(size.width), height: Int(size.height - 100))
        mapMode.frame = CGRect(x: 60, y: top + 40, width: Int(size.width - 120), height: 30)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func changeMap(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            map.mapType = .standard
        }
        if sender.selectedSegmentIndex == 1 {
            map.mapType = .satellite
        }
        if sender.selectedSegmentIndex == 2 {
            map.mapType = .hybrid
        }
    }
}


extension MapViewController : MKMapViewDelegate {
    
}
