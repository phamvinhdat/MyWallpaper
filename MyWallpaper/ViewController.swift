//
//  ViewController.swift
//  MyWallpaper
//
//  Created by pham vinh dat on 11/20/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    let strUrlRoot = "https://pixabay.com/api/?key=10738309-2ce5419b996ea7e48b49dc189"
    var webReturn: WebReturn?
    var searchBar:UISearchBar? = nil
    var isContinue = true
    var currentPage = 1
    var maxPage: Int? = nil
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        loadData(search: nil, page: 2)
        createSearchBar()
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
        var hits: [Pixabay]
    }
    
    fileprivate func loadData(search: String?, page: Int = 1){
        guard maxPage != nil &&  maxPage! > page else {return}
        var strUrl = "\(self.strUrlRoot)&page=\(page)"
        let strSearch = search != nil ? "&q=\(search!)" : ""
        strUrl.append(strSearch)
        guard let url = URL(string: strUrl) else{return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            DispatchQueue.main.async {
                
                if let err = err{
                    print("Failed to get data from URL: ", err)
                    return
                }
                
                guard let data = data else{return}
                
                do{
                    let decoder = JSONDecoder()
                    let temp = try decoder.decode(WebReturn.self, from: data)
                    if self.isContinue{
                        self.webReturn?.hits.insert(contentsOf: temp, at: 0)
                    }
                }catch let jsonErr{
                    print("Failed to decode: ", jsonErr)
                }
                
                self.myTableView.reloadData()
            }
        }.resume()
        
        self.myTableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webReturn != nil ? webReturn!.hits.count : 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! MyTableViewCell
        if let temp = webReturn{
            cell.imgShow.sd_setImage(with: temp.hits[indexPath.row].imgURL, placeholderImage: #imageLiteral(resourceName: "400x200"))
        }else{
            cell.imgShow.image = #imageLiteral(resourceName: "400x200")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let temp = webReturn{
            let width = self.view.frame.width
            let raito = CGFloat(temp.hits[indexPath.row].width) / width
            return CGFloat(temp.hits[indexPath.row].height) / raito
        }else{
            return 200
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < 0{
            print("adsad")
        }
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
