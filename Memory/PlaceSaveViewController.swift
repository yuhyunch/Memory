//
//  PlaceSaveViewController.swift
//  Memory
//
//  Created by Yuhyun Chung on 11/16/18.
//  Copyright © 2018 Yuhyun Chung. All rights reserved.
//

import UIKit
import Alamofire

class PlaceSaveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let list = ["Milk","Honey","Bread"]
    
    var displayLongtitude = "";
    var displayLatitude = "";
    
    //var onFinish: (name: String, name: String)?
    
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.longtitudeLabel.text = displayLongtitude
        self.latitudeLabel.text = displayLatitude

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default , reuseIdentifier: "songCell")
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }
    
    @IBAction func getMyMusic(_ sender: UIButton) {
        
        Alamofire.request("https://api.spotify.com/v1/me/player/recently-played?Authorization=\(Constant.accessToken)&type=track&limit=10&after=1484811043508").responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
            
                print("Result: \(response.result)")                         // response serialization result
        
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
        
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
            }
        
    }
    

}
