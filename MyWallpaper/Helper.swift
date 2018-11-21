//
//  Helper.swift
//  MyWallpaper
//
//  Created by pham vinh dat on 11/21/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import Foundation
import SDWebImage

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

class PixabayQuery{
    private let _strUrlRoot = "https://pixabay.com/api/?key=10738309-2ce5419b996ea7e48b49dc189"
    private var per_page = 20
    var page:Int!
    var strSearch:String!
    var data:WebReturn?
    
    //var isContinue = true
    
    init(){
        page = 1
        strSearch = ""
    }
    
    func getStrQuery()->String{
        var strResult = String()
        
        strResult.append(contentsOf: _strUrlRoot)
        let q:String = "&q=\(String(describing: self.strSearch!))"
        strResult.append(contentsOf: q)
        let strPage:String = "&page=\(String(describing: self.page!))"
        strResult.append(contentsOf: strPage)
        
        return strResult
    }
    
    func ReloadData(_ tableView: UITableView) {
        if let temp = self.data?.totalHits{
            if page > temp/per_page{
                print("Load data faild.")
                return
            }
        }
        
        print(getStrQuery())
        
        guard let url = URL(string: self.getStrQuery()) else{
            print("URL failed")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            DispatchQueue.main.async {
                
                if let err = err{
                    print("Failed to get data from URL: ", err)
                    return
                }
                
                guard let data = data else{
                    print("Data error")
                    return
                }
                
                do{
                    let decoder = JSONDecoder()
                    let temp = try decoder.decode(WebReturn.self, from: data)
                    if self.page > 1{
                        self.data?.hits.insert(contentsOf: temp.hits, at: 0)
                    }else{
                        self.data = temp
                    }
                }catch let jsonErr{
                    print("Failed to decode: ", jsonErr)
                }
                tableView.reloadData()
            }
        }.resume()
    }
}
