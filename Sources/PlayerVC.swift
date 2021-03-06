//
//
//  Created by Максим Ефимов on 16.01.2018.
//

import UIKit
import AVKit

open class PlayerVC: UIViewController {
    private static let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]
    private var playerView: PlayerView = {
        var playerView = PlayerView()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()
    private var toggleButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        return button
    }()
    private var moveBackButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveBack), for: .touchUpInside)
        return button
    }()
    private var moveForwardButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveForward), for: .touchUpInside)
        return button
    }()
    
    private (set) var player: AVQueuePlayer!
    private var playerLayer: AVPlayerLayer? {
        return playerView.playerLayer
    }
    private var MAX_COUNT = 14
    private var MIN_COUNT = 3
    private var items: [URL]!
    private (set) var currentIndex: Int = 0
    private var loopEach: Bool!
    
    public init(_ items: [URL], startIndex: Int = 0, videoGravity: AVLayerVideoGravity = .resizeAspectFill, loopEach: Bool = false){
        super.init(nibName: nil, bundle: nil)
        self.items = items
        self.currentIndex = startIndex
        MAX_COUNT = min(items.count, MAX_COUNT)
        MIN_COUNT = min(items.count, MIN_COUNT)
        playerLayer!.videoGravity = videoGravity
        self.loopEach = loopEach
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        print(#function, currentIndex, MAX_COUNT, items.count)
        
        player = AVQueuePlayer()
        playerView.player = player
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        for i in currentIndex..<min(items.count, currentIndex + MAX_COUNT) {
            addItem(items[i])
        }
        
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.3, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { time in
            if self.player.currentItem != nil {
                self.timeAction(seconds: time.seconds, duration: self.player.currentItem!.duration.seconds)
            }
        }
        
        modalPresentationStyle = .overFullScreen
        
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        
        setupViews()
        itemDidChange()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player.pause()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    internal func setupViews(){
        view.backgroundColor = .black
        navigationItem.title = ""
        view.addSubview(playerView)
        playerView.addSubview(moveBackButton)
        playerView.addSubview(moveForwardButton)
        playerView.addSubview(toggleButton)
        
        playerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        playerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        moveBackButton.topAnchor.constraint(equalTo: playerView.topAnchor).isActive = true
        moveBackButton.leftAnchor.constraint(equalTo: playerView.leftAnchor).isActive = true
        moveBackButton.widthAnchor.constraint(equalToConstant:50).isActive = true
        moveBackButton.bottomAnchor.constraint(equalTo: playerView.bottomAnchor).isActive = true
        
        moveForwardButton.rightAnchor.constraint(equalTo:playerView.rightAnchor).isActive = true
        moveForwardButton.widthAnchor.constraint(equalToConstant:50).isActive = true
        moveForwardButton.topAnchor.constraint(equalTo: playerView.topAnchor).isActive = true
        moveForwardButton.bottomAnchor.constraint(equalTo:playerView.bottomAnchor).isActive = true
        
        toggleButton.leftAnchor.constraint(equalTo: moveBackButton.rightAnchor).isActive = true
        toggleButton.rightAnchor.constraint(equalTo: moveForwardButton.leftAnchor).isActive = true
        toggleButton.topAnchor.constraint(equalTo: playerView.topAnchor).isActive = true
        toggleButton.bottomAnchor.constraint(equalTo:playerView.bottomAnchor).isActive = true
    }
    
    func timeAction(seconds: Double, duration: Double) {}
    
    public func itemDidChange() {}
    
    @objc public func itemDidEnd() {
        print(#function)
        if loopEach {
            replay()
        }
        else {
            if !moveForward() {}
        }
    }
    
    @objc public func toggle() {
        if let currentTime = player.currentItem?.currentTime().seconds, let duration = player.currentItem?.duration.seconds, currentTime > duration {
            replay()
        }
        else if player.rate != 0 {
            player.pause()
        }
        else {
            player.play()
        }
    }
    
    public func replay() {
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        player.play()
    }
    
    //Добавляем текущий элемент после текущего элемента потом добавляем предыдущий элемент после текущего к переходим к нему
    @objc public func moveBack() {
        if currentIndex > 0 {
            addItem(items[currentIndex], toBack: false)
            currentIndex-=1
            addItem(items[currentIndex], toBack: false)
            player.advanceToNextItem()
            itemDidChange()
        }
    }
    
    @objc public func moveForward() -> Bool {
        if currentIndex < items.count - 1 {
            player.advanceToNextItem()
            
            let leftCount = player.items().count
            currentIndex += 1
            print(#function, leftCount)
            if(leftCount <= MIN_COUNT){
                let startIndex = currentIndex + leftCount
                let endIndex = min(startIndex + (MAX_COUNT - MIN_COUNT), items.count)
                print("can add new answers", startIndex, endIndex)
                for i in startIndex..<endIndex {
                    addItem(items[i])
                }
            }
            itemDidChange()
            return true
        }
        return false
    }
    
    @objc func close(){
        clear()
        self.dismiss(animated: true)
    }
    
    private func addItem(_ url: URL, toBack: Bool = true){
        print(#function, url.absoluteString)
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: PlayerVC.assetKeysRequiredToPlay)
        
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        player.insert(playerItem, after: toBack ? nil : player.items()[0])
    }
    
    private func clear(){
        if playerLayer != nil && playerLayer!.player != nil {
            print(#function)
            player.pause()
            player.removeAllItems()
            playerLayer!.player = nil
        }
    }
    
    deinit {
        print(#function)
        clear()
    }
}
