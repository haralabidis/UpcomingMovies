//
//  ViewController.swift
//  UpcomingMovies
//
//  Created by Patrick Haralabidis on 13/07/2014.
//  Copyright (c) 2014 Patrick Haralabidis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
                            
    @IBOutlet var appTableView: UITableView
    var searchResultsData: NSArray = []
    var api: APIController = APIController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Construct the API URL that you want to call
        var APIkey: String = "" //Replace with your Api Key"
        var APIBaseUrl: String = "http://api.themoviedb.org/3/movie/upcoming?api_key="
        var urlString:String = "\(APIBaseUrl)" + "\(APIkey)"
        
        //Call the API by using the delegate and passing the API url
        self.api.delegate = self
        api.GetAPIResultsAsync(urlString)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return searchResultsData.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cellIdentifier: String = "MovieResultsCell"
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        //Create a variable that will contain the result data array item for each row
        var cellData: NSDictionary = self.searchResultsData[indexPath.row] as NSDictionary
        //Assign and display the Title field
        cell.textLabel.text = cellData["title"] as String
        
        // Construct the posterUrl to get an image URL for the movie thumbnail
        var baseUrl: String = "http://image.tmdb.org/t/p/w300"
        var movieUrlString: String? = cellData["poster_path"] as? String
        var urlString: String? = "\(baseUrl)" + "\(movieUrlString)"
        var imgURL: NSURL = NSURL(string: urlString)
        
        // Download an NSData representation of the image at the URL
        var imgData: NSData = NSData(contentsOfURL: imgURL)
        cell.imageView.image = UIImage(data: imgData)
        
        // Get the release date string for display in the subtitle
        var releaseDate: String = cellData["release_date"] as String
        
        cell.detailTextLabel.text = releaseDate
        
        return cell
    }
    
    func JSONAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.searchResultsData = results
            self.appTableView.reloadData()
            })
    }



}

