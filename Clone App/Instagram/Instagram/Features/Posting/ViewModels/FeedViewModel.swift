//
//  FeedViewModel.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/21.
//

import Combine

class FeedViewModel {
    
    //MARK: - Properties
    @Published var posts = [PostModel]()
    
    @Published var post: PostModel?
    
    let apiClient: ServiceProviderType
    
    init(post: PostModel? = nil, apiClient: ServiceProviderType) {
        self.post = post
        self.apiClient = apiClient
    }
}

extension FeedViewModel: FeedViewModelType {
    
    func transform(with input: Input) -> Output {
        
        let initData = input.initData.map{ _ -> State in
            self.fetchPosts()
            self.checkIfUserLikePosts()
            return .reloadData
        }.eraseToAnyPublisher()
        
        let loadPosts = $posts.map{ _ -> State in
            return .reloadData
        }.eraseToAnyPublisher()
        
        let loadPost = $post.map { _ -> State in
            return .reloadData
        }.eraseToAnyPublisher()
        
        let appear = input.appear.map {_ -> State in
            return .appear
        }.eraseToAnyPublisher()
        
        let logout = input.logout.map{_ -> State in
            return .callLoginCoordinator
        }.eraseToAnyPublisher()
        
        let refresh = input.refresh.map { _ -> State in
            self.posts.removeAll()
            self.fetchPosts()
            return .reloadData
        }.eraseToAnyPublisher()
        
        return Publishers.Merge6(
            initData,loadPost,
            loadPosts,appear,logout,
            refresh).eraseToAnyPublisher()
    }
    
}

extension FeedViewModel: FeedViewModelComputedProperty {
    
    var getPost: PostModel? {
        return post
    }
    
    var count: Int {
        return post != nil ? 1 : posts.count
    }
    var isEmptyPost: Bool {
        guard post != nil else { return true }
        return false
    }
}

//MARK: - APIs
extension FeedViewModel {
    func fetchPosts() {
        guard post == nil else { return }
        Task(priority: .high) {
            do {
                var posts = try await apiClient.postCase.fetchPosts()
                posts.sort() { $0.timestamp.seconds > $1.timestamp.seconds }
                self.posts = posts
            }catch {
                print("DEBUG: Unexpected error occured: \(error.localizedDescription)")
            }
        }
    }
    
    func checkIfUserLikePosts() {
        _=posts.map { post in
            Task() {
                let didLike = await apiClient
                    .postCase
                    .checkIfUserLikedPost(post: post)
                if let idx = self.posts.firstIndex(where: {$0.postId == post.postId}) {
                    self.posts[idx].didLike = didLike
                }
            }
        }
    }
    
}
