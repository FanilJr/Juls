//
//  NewsListController.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit

class NewsListController: UIViewController {
    
    var downloadManager = DownloadManager()
    var articles: [Article] = []
    var refreshControle = UIRefreshControl()
    let juls = JulsView()
    
    var searchController = UISearchController(searchResultsController: nil)

    let background: UIImageView = {
        let back = UIImageView()
        back.clipsToBounds = true
        back.image = UIImage(named: "back")
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    private var activityView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityView.color = .white
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.refreshControl = refreshControle
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityView.stopAnimating()
    }
    
    private func setupDidLoad() {
        self.title = "Новости"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        refreshControle.attributedTitle = NSAttributedString(string: "Обновление")
        refreshControle.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        activityView.startAnimating()
        
        layout()
        tableView.dataSource = self
        tableView.delegate = self
        
        downloadNewsList { articles in
            DispatchQueue.main.async {
                self.articles = articles ?? []
                self.tableView.reloadData()
            }
        }
    }

    @objc func didTapRefresh() {
        downloadNewsList { articles in
            DispatchQueue.main.async {
                self.articles = articles ?? []
                self.tableView.reloadData()
                self.refreshControle.endRefreshing()
            }
        }
    }
    
    func layout() {
        [tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

    // MARK: - Table view data source
    
extension NewsListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = .createColor(light: .white, dark: .systemGray5)
        cell.setupCell(articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        ArticleViewController.show(self, article: article)
    }
}

extension NewsListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}



