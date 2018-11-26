//
//  ViewController.swift
//  MyWallpaper
//
//  Created by pham vinh dat on 11/20/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView!
    var searchBar:UISearchBar? = nil
    let pixabayLoader = PixabayQuery()
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setActivityIndicator_viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.keyboardDismissMode = .onDrag
        myTableView.separatorColor = UIColor.clear
        pixabayLoader.ReloadData(myTableView, activityIndicator)
        createSearchBar()
    }
    
    private func setActivityIndicator_viewDidLoad(){
        activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: self.view.center, size: CGSize(width: 50, height: 50)))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        activityIndicator.color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        self.view.addSubview(activityIndicator)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pixabayLoader.data != nil ? self.pixabayLoader.data!.hits.count : 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! MyTableViewCell
        
        if let temp = self.pixabayLoader.data{
            cell.activityIndicator.startAnimating()
            cell.imgShow.sd_setImage(with: temp.hits[indexPath.row].imgURL, placeholderImage: #imageLiteral(resourceName: "400x200"), options: [.progressiveDownload]) { (image, error, imageCache, url) in
                if let er = error{
                    cell.lblUser.text = "\(er)"
                    cell.lblUser.textColor = UIColor.red
                }
                cell.activityIndicator.stopAnimating()
            }
            cell.lblUser.text = temp.hits[indexPath.row].user
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
        let contentYoffset = scrollView.contentOffset.y
        
        //refresh data
        if contentYoffset < 0{
            self.pixabayLoader.page = 1
            self.pixabayLoader.ReloadData(self.myTableView, activityIndicator)
        }else{//if the user pulls the table down then reload data
            let height = scrollView.frame.size.height
            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
            if distanceFromBottom < height {
                self.pixabayLoader.page += 1
                self.pixabayLoader.ReloadData(self.myTableView, activityIndicator)
            }
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
        self.searchBar?.text = ""
        self.pixabayLoader.strSearch = ""
        self.pixabayLoader.ReloadData(self.myTableView, activityIndicator)
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
        self.myTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        self.pixabayLoader.ReloadData(self.myTableView, activityIndicator)
    }
}
