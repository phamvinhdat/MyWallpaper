//
//  ViewController.swift
//  MyWallpaper
//
//  Created by pham vinh dat on 11/20/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let strURL = "https://pixabay.com/api/?key=10738309-2ce5419b996ea7e48b49dc189"
    var webReturn: WebReturn?
    var searchBar:UISearchBar? = nil
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        loadData()
    }
    
    struct Pixabay: Decodable{
        let width: Int
        let height: Int
        let imgURL: URL
        let tags: String
        
        private enum CodingKeys: String, CodingKey {
            case width = "imageWidth"
            case height = "imageHeight"
            case imgURL = "largeImageURL"
            case tags
        }
    }
    
    struct WebReturn: Decodable{
        let totalHits: Int
        let hits: [Pixabay]
    }
    
    fileprivate func loadData(){
        guard let url = URL(string: strURL) else{return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            DispatchQueue.main.async {
                if let err = err{
                    print("Failed to get data from URL: ", err)
                    return
                }
                
                guard let data = data else{return}
                
                do{
                    let decoder = JSONDecoder()
                    self.webReturn = try decoder.decode(WebReturn.self, from: data)
                }catch let jsonErr{
                    print("Failed to decode: ", jsonErr)
                }
                self.myTableView.reloadData()
            }
            }.resume()
        self.myTableView.reloadData()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webReturn != nil ? webReturn!.hits.count : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! MyTableViewCell
        if let temp = webReturn{
            cell.textLabel?.text = temp.hits[indexPath.row].tags
            //cell.imgShow.image
        }else{
            cell.textLabel?.text = "dmm: \(indexPath.row)"
            cell.imgShow.image = #imageLiteral(resourceName: "400x200")
        }
        return cell
    }
    
    
}

extension ViewController: UISearchBarDelegate{
    func createSearchBar(){
        self.searchBar = UISearchBar()
        self.searchBar?.placeholder = "Search Photos"
        self.searchBar?.showsCancelButton = true
        self.navigationItem.titleView = self.searchBar
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.searchBar?.delegate = self
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar?.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let alert = UIAlertController(title: "Datcay", message: "Da bam search button", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
