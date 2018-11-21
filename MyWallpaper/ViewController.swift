//
//  ViewController.swift
//  MyWallpaper
//
//  Created by pham vinh dat on 11/20/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var searchBar:UISearchBar? = nil
    let pixabayLoader = PixabayQuery()
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.keyboardDismissMode = .onDrag
        pixabayLoader.ReloadData(myTableView)
        createSearchBar()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pixabayLoader.data != nil ? self.pixabayLoader.data!.hits.count : 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! MyTableViewCell
        if let temp = self.pixabayLoader.data{
            cell.imgShow.sd_setImage(with: temp.hits[indexPath.row].imgURL, placeholderImage: #imageLiteral(resourceName: "400x200"), options: [.progressiveDownload], completed: nil)
        }else{
            cell.imgShow.image = #imageLiteral(resourceName: "400x200")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let temp = self.pixabayLoader.data{
            let width = self.view.frame.width
            let raito = CGFloat(temp.hits[indexPath.row].width) / width
            return CGFloat(temp.hits[indexPath.row].height) / raito
        }else{
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: "IMAGE_VIEW") as! ImageViewController
        let cell = tableView.cellForRow(at: indexPath) as! MyTableViewCell
        sb.myImg = cell.imgShow.image!
        
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y < 0{
            self.pixabayLoader.page += 1
            self.pixabayLoader.ReloadData(self.myTableView)
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
        self.searchBar?.endEditing(true)
        let SPACE:Character = " "
        let txtSearch = self.searchBar?.text
        var strSearch:String = ""
        
        self.pixabayLoader.page = 1
        self.pixabayLoader.data = nil
        
        if let subSearch = txtSearch?.split(separator: SPACE, maxSplits: 255, omittingEmptySubsequences: true){
            self.pixabayLoader.page = 1
            strSearch = String()
            for token in subSearch{
                strSearch.append(contentsOf: token)
                strSearch.append("+")
            }
        }
        if strSearch.last == "+"{
            strSearch.removeLast()
        }
        
        self.pixabayLoader.strSearch = strSearch
        self.pixabayLoader.ReloadData(self.myTableView)
    }
}
