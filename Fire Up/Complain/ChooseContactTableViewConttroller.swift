//
//  ChooseContactTableViewConttroller.swift
//  Fire Up
//
//  Created by HuangHanxun on 11/4/15.
//  Copyright © 2015 sunkai. All rights reserved.
//

import Foundation
import UIKit

class ChooseContactTableViewConttroller: PFQueryTableViewController, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    
    var searchString = ""
    var searchInProgress = false

    
    required init(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)!
        self.parseClassName = "User"
        self.textKey = "username"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 25
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        
    }

    override func queryForTable() -> PFQuery! {
        let query = PFUser.query()
        if searchInProgress{
            query.whereKey("username", containsString: searchString)
        }
        if self.objects.count == 0{
            query.cachePolicy = kPFCachePolicyCacheThenNetwork
        }
        query.orderByAscending("username")
        return query
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
        print("SearchBarChange");
        searchInProgress = true
        self.loadObjects()
        searchInProgress = false
    }
    
    
}