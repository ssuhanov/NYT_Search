//
//  TableViewController.swift
//  NYT_Search
//
//  Created by Serge Sukhanov on 09.07.16.
//  Copyright © 2016 Serge Sukhanov. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {

    var arrayOfArticles = [Article]()
    let beginOfArticlesURL = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q="
    let endOfArticlesURL = "&sort=newest&api-key=d4e97cffa4f24a59b5f637aecd91b440"
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "NY Times"
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.text = "New York"
        searchController.searchBar.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
        
        getArticles("New York")
    }
    
    func stringForSearch(searchString: String) -> String {
        var result = ""
        let searchStringArray = searchString.componentsSeparatedByString(" ")
        for (index,element) in searchStringArray.enumerate() {
            if index != 0 {
                result += "+"
            }
            result += element
        }
        
        return result
    }
    
    // MARK: - Search bar delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            getArticles(searchText)
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfArticles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ArticleCell
        let article = arrayOfArticles[indexPath.row]
        cell.article = article
        cell.configureCell()

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let article = arrayOfArticles[indexPath.row]
        if let url = NSURL(string: NSLocalizedString(article.link, comment: "")) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    // MARK: - Getting data from URL
    func getArticles(searchString: String) {
        let request = NSURLRequest(URL: NSURL(string: beginOfArticlesURL+stringForSearch(searchString)+endOfArticlesURL)!)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            //Parsing
            if let data = data {
                self.parseJsonData(data)
            }
            
        }
        task.resume()
    }
    
    func parseJsonData(data: NSData) {
        if !arrayOfArticles.isEmpty {
            arrayOfArticles = [Article]()
        }
        
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            if let jsonResult = jsonResult as? [String : AnyObject] {
                if let jsonResponse = jsonResult["response"] as? [String : AnyObject] {
                    if let jsonDocsArray = jsonResponse["docs"] as? [[String : AnyObject]] {
                        for jsonElement in jsonDocsArray {
                            let article = Article(jsonDictionary: jsonElement)
                            arrayOfArticles.append(article)
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
        } catch {
            print(error)
        }
    }

}
