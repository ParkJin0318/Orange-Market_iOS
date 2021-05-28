//
//  LocalPostListViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import ReactorKit

class LocalPostListViewReactor: Reactor {
    
    private lazy var localRepository: LocalRepository = LocalRepositoryImpl()
    
    var initialState: State = State(
        localPosts: [],
        tapPostItem: nil,
        localTopics: [],
        tapTopicItem: nil,
        currentCity: nil,
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case fetchLocalPost
        case filterLocalPost(Int)
        case fetchLocalTopic
        case tapPostItem(Int)
        case tapTopicItem(Int)
    }
    
    enum Mutation {
        case setLocalPost([LocalPost])
        case setTapPostItem(Int)
        case setLocalTopic([LocalTopic])
        case setTapTopicItem(Int)
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var localPosts: [LocalPost]
        var tapPostItem: Int?
        var localTopics: [LocalTopic]
        var tapTopicItem: LocalTopic?
        var currentCity: String?
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .fetchLocalPost:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    localRepository.getAllLocalPost()
                        .asObservable()
                        .map { Mutation.setLocalPost($0) },
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case let .filterLocalPost(idx):
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    localRepository.getAllLocalPost(topicIdx: idx)
                        .asObservable()
                        .map { Mutation.setLocalPost($0) },
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case .fetchLocalTopic:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    localRepository.getAllTopic()
                        .asObservable()
                        .map { Mutation.setLocalTopic($0) },
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case let .tapPostItem(index):
                return Observable.just(Mutation.setTapPostItem(index))
                
            case let .tapTopicItem(index):
                return Observable.just(Mutation.setTapTopicItem(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        state.tapPostItem = nil
        state.tapTopicItem = nil
        
        switch mutation {
            case let .setLocalPost(posts):
                state.localPosts = posts
                state.currentCity = posts.first?.city
                
            case let .setTapPostItem(index):
                state.tapPostItem = state.localPosts[index].idx
                
            case let .setLocalTopic(topics):
                var localTopics: [LocalTopic] = []
                localTopics.append(LocalTopic(idx: 0, name: "카테고리", isSelected: false))
                localTopics.append(contentsOf: topics)
                state.localTopics = localTopics
                
            case let .setTapTopicItem(index):
                state.tapTopicItem = state.localTopics[index]
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        return state
    }
}
