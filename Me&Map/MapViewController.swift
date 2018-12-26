import UIKit
import CoreLocation
import MapKit

extension String {
    func mySlice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

class MapViewController: UIViewController {
    private let mapMode = UISegmentedControl(items: ["Map", "Satellite", "Mix"])
    private let map = MKMapView()
    private let textField = UITextField()
    private var map_API_key = String()
    
    
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
        
        //TextField
        textField.backgroundColor = UIColor.white
        textField.becomeFirstResponder()
        textField.delegate = self
        
        //DELETE THIS!!!!!!!!
        map_API_key = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.yellow
        
        //addsubview
        self.view.addSubview(textField)
        self.view.addSubview(map)
        self.view.addSubview(mapMode)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMap), name: NSNotification.Name(rawValue: "updateMap"), object: nil)

        self.displayInSize(size: UIScreen.main.bounds.size)
    }
    
    
    func displayInSize(size: CGSize) {
        let top = 70
        textField.frame = CGRect(x: 0, y: top, width: Int(size.width), height: 30)
        map.frame = CGRect(x: 0, y: top + 35, width: Int(size.width), height: Int(size.height - 100))
        mapMode.frame = CGRect(x: 60, y: top + 40, width: Int(size.width - 120), height: 30)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        displayInSize(size: size)
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
    
    @objc func fetchData() {
        let stringText = textField.text
        let stringReplaced = stringText!.replacingOccurrences(of: " ", with: "+")
        let computed = "https://maps.googleapis.com/maps/api/geocode/xml?address=\(stringReplaced)&sensor=false&key=\(map_API_key)"
        let myURL = URL(string: computed)
        if myURL != nil {
            let request = URLRequest(url: myURL!)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request) {(data, resp, err) in 
                DispatchQueue.main.async {
                    if err != nil {
                        let a = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: .alert)
                        a.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(a, animated: true, completion: nil)
                    } else if data != nil {
                        self.handleData(data!)
                    } else {
                        print("Empty data")
                    }
                }
            }
            task.resume()
        } else {
            print("URL failure!!!")
        }
    }
    
    func handleData(_ d: Data){
        let s = String(decoding: d, as: UTF8.self)
        let sStatus = s.mySlice(from: "<status>", to: "</status>")
        if sStatus == "OK" {
            let sAddress = s.mySlice(from: "<formatted_address>", to: "</formatted_address>")
            let sLocation = s.mySlice(from: "<location>", to: "</location>")
            let sLattitude = Double((sLocation!.mySlice(from: "<lat>", to: "</lat>"))!)
            let sLongitude = Double((sLocation!.mySlice(from: "<lng>", to: "</lng>"))!)
            print("DATA===================")
            print(sStatus ?? "sStatus = NULL")
            print(s)
            print("=======================")
            addCell(address: sAddress!, lattitude: sLattitude!, longitude: sLongitude!)
            updateLocation(lat: sLattitude!, lng: sLongitude!)
        } else {
            print("handleData ERROR")
        }
    }
    
    @objc func updateMap(){
        var cont : OneCell?
        if let tbc = self.tabBarController as? MyCustomTabController {
            cont = tbc.content[tbc.index]
            print(cont?.lattitude as Any, cont?.longitude as Any)
        } else if let svc = self.splitViewController as? MyCustomSplitViewController {
            cont = svc.content[svc.index]
        } else {
            print("updateMap ERROR")
        }
        updateLocation(lat: (cont?.lattitude)!, lng: (cont?.longitude)!)
    }
    
    
    @objc func addCell(address: String, lattitude: Double, longitude: Double) {
        let newCell = OneCell(add: address, lat: lattitude, lng: longitude)
        if let tbc = self.tabBarController as? MyCustomTabController {
            tbc.content.append(newCell)
        } else if let svc = self.splitViewController as? MyCustomSplitViewController {
            svc.content.append(newCell)
        } else {
            print("error put in table")
        }
    }
    
    func updateLocation(lat: Double, lng: Double) {
        let thisLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
        // Map update
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: thisLocation, span: span)
        map.setRegion(region, animated: true)
    }
}



extension MapViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn ======")
        textField.resignFirstResponder()
        fetchData()
        return true
    }
}
