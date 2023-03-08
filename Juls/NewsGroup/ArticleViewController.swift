//
//  ArticleViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit

class ArticleViewController: UIViewController {

    var webVC = WebViewController()
    var articles: Article!
    var downloadManager = DownloadManager()
    let juls = JulsView()

    let background: UIImageView = {
        let back = UIImageView()
        back.clipsToBounds = true
        back.image = UIImage(named: "back")
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "ArticleTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupDidLoad() {
        view.backgroundColor = .white
        title = articles.title
        layout()
        self.navigationItem.largeTitleDisplayMode = .never
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func layout() {
        [background, tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: background.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: background.bottomAnchor)
        ])
    }
    
    static func show(_ viewController: UIViewController, article: Article) {
        let ac = ArticleViewController()
        ac.articles = article
        viewController.navigationController?.pushViewController(ac, animated: true)
    }
}

extension ArticleViewController: UITableViewDataSource, URLDelegate {
    
    func tapInURL() {
        let myURL = URL(string: articles.url!)
        let request = URLRequest(url: myURL!)
        let navVC = UINavigationController(rootViewController: webVC)
//        webVC.title = "Browser JR"
        webVC.web.load(request)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.webVC.web.evaluateJavaScript("document.body.innerHTML") { result, error in
                guard let _ = result as? String, error == nil else {
                    return
                }
            }
        }
        present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        cell.backgroundColor = .createColor(light: .white, dark: .systemGray5)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.titleName.text = articles.title
        cell.descriptionName.text = articles.description
        cell.name.text = articles.name
        cell.url.text = articles.url
        cell.date.text = articles.publishedAt
        cell.delegate = self

        /// Удаляем не нужные символы в дате и времени
        let result = cell.date.text?.replacingOccurrences(of: "T", with: "  ")
        cell.date.text = result
        
        for i in cell.date.text! {
            if i == "Z" {
                cell.date.text?.removeAll(where: { character in
                    i == character
                })
            }
        }
        
        if let urlImageString = articles.urlToImage,
           let urlimage = URL(string: urlImageString) {
            downloadManager.downloadFile(url: urlimage) { data in
                guard let data else {
                    return
                }
                DispatchQueue.main.async {
                    cell.postImage.image = UIImage(data: data)
                }
            } didWriteData: { percentCompleted in
                DispatchQueue.main.async {
                    cell.progress.progress = percentCompleted
                }
            }
        }
        return cell
    }
}


extension ArticleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}


