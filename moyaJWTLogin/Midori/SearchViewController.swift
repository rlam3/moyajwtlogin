//
//  SearchViewController.swift
//  Midori
//
//  Created by Raymond Lam on 4/15/15.
//  Copyright (c) 2015 Midori. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics
import RxSwift
import Moya_ModelMapper
import FlatUIColors

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {

    ///
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var searchResultTableView: UITableView!

    
    let disposeBag = DisposeBag()
    var provider: Networking!
    var searchResults: [SearchResultMap] = []
    
    // Rx 
//    var rx_searchModel: SearchRxModel!
//    var latstSearchTerm: Observable<String>{
//        return searchBar.rx.text.orEmpty
//            .throttle(0.5, scheduler: MainScheduler.instance)
//            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
//        searchResultTableView.keyboardDismissMode = .interactive
        self.hideKeyboardWhenTappedAround()
        setupRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        setupColors()
    }
    
    func setupColors() {
        
        self.searchBar.barTintColor = FlatUIColors.emerald()
        
    }
    
    func setupRx() {
        provider = Networking.newDefaultNetworking()
    }
    
    func loadDataNew(_ term: String){

        provider.request(.searchForTerm(term: term))
        .debug("loadDataNew in Search")
        .filterSuccessfulStatusCodes()
        .map(to: [SearchResultMap].self, keyPath: "data")
        .subscribe{ (event) in
            
            // Here we subscribe to every new value
            
            switch event{
            case .next(let searchedResults):
                
                self.searchResults = searchedResults
                self.searchResultTableView.reloadData()
                
            case .error(let error):
                
                self.handleError(error:error, term:term)
                
            default: break
            }
            }.disposed(by: disposeBag)
        
    }
    
    func handleError(error:Error, term:String) {
        
        Answers.logSearch(withQuery: "midori search failure",
                          customAttributes: [
                            "term": term,
                            ])
        
        Crashlytics.sharedInstance().recordError(error)
        
        print("ERROR:::::: \(error)")
    }
    
    
    /// FIXME: Rx All code way. Would be nice to use this way
//    func setupRx() {
//        rx_searchModel = SearchRxModel(provider: Networking.newDefaultNetworking(), latestSearchTerm: self.latstSearchTerm)
//        
//        rx_searchModel
//            .findOrganization()
//            .bindTo(searchResultTableView.rx.items){ (tableView, row, item) in
//                let cell = self.searchResultTableView.dequeueReusableCell(withIdentifier: "searchResultCell", for:IndexPath(row: row, section: 0) ) as! SearchTableViewCell
//                cell.textLabel?.text = item.display_name
//                return cell
//        }.addDisposableTo(disposeBag)
//        
//        searchResultTableView.rx
//            .itemSelected
//            .subscribe{ indexPath in
//                self.performSegue(withIdentifier: "showOrganizationHome", sender: self)
//            }.addDisposableTo(disposeBag)
//    }
    

    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }

    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultTableView.dequeueReusableCell(withIdentifier: "searchResultCell") as! SearchTableViewCell

        let result = searchResults[indexPath.row]

        cell.configureNew(result)

        return cell
    }

    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "showOrganizationHome", sender: self)
        searchResultTableView.deselectRow(at: indexPath, animated: true)

    }

    ///
    override func prepare(for segue: (UIStoryboardSegue!), sender: Any!) {

        if segue.identifier == "showOrganizationHome" {

            let selectedResult = self.searchResults[self.searchResultTableView.indexPathForSelectedRow!.row]

            let orgHomeView = segue.destination as! OrganizationHomeViewController

            orgHomeView.organization = selectedResult
            
        }
    }


    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }


    // MARK: - Search

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Need to strip query and have search Text be cleaned before it can enter through api
        if searchText.isEmpty || searchText == " "{
            self.searchResults = []
            self.searchResultTableView.reloadData()
        }else{
            loadDataNew(searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadDataNew(searchBar.text!)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // Removes keyboard when scrolling begins
        searchBar.resignFirstResponder()
        
    }
    
    
}
