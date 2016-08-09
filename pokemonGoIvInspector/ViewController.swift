//
//  ViewController.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/8.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit
import PokemonKit

class ViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var searchBar: UISearchBar!
    //var dataSource: Array?
    
    /// Search controller to help us with filtering.
    var searchController: UISearchController!
    
    /// Secondary search results table view.
    var resultsTableController: PokeSearchResultsController!
    
    var pokemons: [PKMPokemon]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        resultsTableController = PokeSearchResultsController()
        resultsTableController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
        /*
         Search is now just presenting a view controller. As such, normal view controller
         presentation semantics apply. Namely that presentation will walk up the view controller
         hierarchy until it finds the root view controller or one that defines a presentation context.
         */
        definesPresentationContext = true
        
        tester()
        
        getPokemons()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell != nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.text = "test"
        
        return cell!
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: UISearchControllerDelegatea
    
    func presentSearchController(searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // Update the filtered array based on the search text.
        
        //        let searchResults = pokemons
        //        let searchString = searchController.searchBar.text
        //
        //        let predicate = NSPredicate(format: "SELF CONTAINS[cd] %@", searchString!)
        //        let filteredResults = searchResults.filter { predicate.evaluateWithObject($0) }
        //
        //        let resultsController = searchController.searchResultsController as! PokeSearchResultsController
        //        resultsController.filteredCountries = filteredResults
        //        resultsController.tableView.reloadData()
    }
    
    // MARK: - Tester
    
    func tester() {
        
        PokemonKit.fetchBerry("1")
            .then { berryInfo in
                //self.testLabel.text = berryInfo.name;
                log.debug("berryInfo: \(berryInfo)")
                
            }.onError {error in
                print(error)
        }
        
        PokemonKit.fetchPokemons()
            .then { mons in
                log.debug("mons: \(mons)")
                let results = mons.results
                
            }.onError { error in
                print(error)
        }
    }
    
    func getPokemons() {
        
    }
    
}

