//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by Anoop tomar on 2/6/15.
//  Copyright (c) 2015 devtechie.com. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var movieArray : NSArray?
    let refreshControl1: UIRefreshControl! = UIRefreshControl()
    var currentPage = 1;
    var movies : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl1.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl1, atIndex: 0)
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?page_limit=16&page=\(currentPage)&country=us&apikey=vzmkwz3xmfdk23srbt83yaxj";
        loadMovies(RottenTomatoesURLString)
        
        self.navigationItem.title = "DVD Movies"
        self.navigationItem.backBarButtonItem?.title = "DVD Movies"
    }
    
    func onRefresh(){
        currentPage++;
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?page_limit=16&page=\(currentPage)&country=us&apikey=vzmkwz3xmfdk23srbt83yaxj";
        loadMovies(RottenTomatoesURLString);
        
    }
    
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        var nav = self.navigationController?.navigationBar;
        
        nav?.tintColor = UIColor.yellowColor();
        nav?.barStyle = UIBarStyle.Black;
        nav?.alpha = 0.8;
    }
    
    func loadMovies(url: String){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        downloadMovies(url, {
            data in self.movies = data
            self.movieArray = self.movies
            self.tableView.reloadData();
            self.refreshControl1.endRefreshing();
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        });
        
    }
    
    func downloadMovies(url: String, successcallback:(NSArray!) -> Void){
        
        if(!self.errorLbl.hidden){
            self.errorLbl.hidden = true;
        }
        
        let manager = AFHTTPRequestOperationManager();
        manager.GET(url, parameters: nil, success: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            if let result = responseObject["movies"] as? NSArray{
                successcallback(result);
            }
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                if(error.code == -1009){
                    self.errorLbl.hidden = false;
                    self.refreshControl1.endRefreshing();
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = movieArray{
            if(array.count<16){
                self.currentPage = 1;
            }
            return array.count;
        }else{
            return 0;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movie = self.movieArray![indexPath.row] as NSDictionary;
        let cell : MovieCustomCell = tableView.dequeueReusableCellWithIdentifier("com.devtechie.customcell") as MovieCustomCell;
        var moviePosters = movie["posters"] as NSDictionary
        var movieThumbnail = moviePosters["thumbnail"] as NSString
        cell.movieThumbnail?.setImageWithURL(NSURL(string: movieThumbnail));
        cell.movieTitleLbl.text = movie["title"] as NSString;
        cell.movieDescLbl.text = movie["synopsis"] as NSString;
        
        var bgView = UIView();
        bgView.backgroundColor = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1);
        cell.selectedBackgroundView = bgView;
        return cell;
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "movieDetails"){
            let details:MovieDetailsViewController = segue.destinationViewController as MovieDetailsViewController;
            var selectedMovieIndex = self.tableView.indexPathForSelectedRow()!;
            let movie = self.movieArray![selectedMovieIndex.row] as NSDictionary;
            details.movieDictionary = movie;
        }
    }
}
