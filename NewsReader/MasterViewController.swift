//
//  MasterViewController.swift
//  NewsReader
//
//  Created by Mahjeed Marrow on 5/6/19.
//  Copyright © 2019 Mahjeed Marrow. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate {
    //MARK: outlets
    @IBOutlet weak var searchBar: UISearchBar!

    var articles =  [News]()
    var newsService: NewsService!
    var selectedArticle = News?.self
    
    var detailViewController: DetailViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        searchBar.delegate = self
        self.newsService = NewsService()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBarSearchInitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Search bar handling
    //source: shrikar.com/swift-ios-tutorial-uisearchbar-and-uisearchbardelegate/
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        
        self.newsService.search(for: searchText ?? "Apple", completion: { articles, error in
            guard let articles = articles, error == nil else {
                print(error ?? "unknown error")
                return
            }
            self.articles = articles
            self.tableView.reloadData()})
    }
    
    func searchBarSearchInitial() {
        let searchText = "Apple"
        
        self.newsService.search(for: searchText , completion: { articles, error in
            guard let articles = articles, error == nil else {
                print(error ?? "unknown error")
                return
            }
            self.articles = articles
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view formatting
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight = CGFloat(115.0)
        return defaultHeight
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let article = articles[indexPath.row]
                let controller = segue.destination as? DetailViewController
                
                controller?.article = article
                controller?.articleUrl = article.url
                controller?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller?.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }

// MARK: - Table view data source
extension MasterViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! SearchTableViewCell
        
        let article = articles[indexPath.row]
        let articleDate = article.publishedAt ?? "2000-01-01T16:30:00Z"
        let formattedArticleDate = convertToDateFormat(publishDateString: articleDate) ?? Date()
        
        newsCell.titleLabel?.text = article.title
        
        if isArticleRecent(formattedArticleDate) {
            newsCell.recentLabel?.text = "RECENT"
            newsCell.nameLabel?.text = article.author
        } else {
            newsCell.recentLabel?.text = article.author
            }
        return newsCell
    }
    
    //MARK: article date handling
    func isArticleRecent(_ publishDate: Date) -> Bool {
        let todaysDate = Date()
        if getDaysSincePublishDate(publishDate, todaysDate) < 31 {
            return true
        } else {
            return false }
    }
    
    func getDaysSincePublishDate(_ publishDate: Date,_ todaysDate: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: publishDate, to: todaysDate).day ?? 31
    }
    
    //source: stackoverflow.com/questions/36861732/convert-string-to-date-in-swift/36862162#36862162
    func convertToDateFormat(publishDateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: publishDateString)
    }
}

//MARK: alert handling
//this probably isn't the right place for this...
extension MasterViewController {
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "errorAlerter", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
