enum FetchResult<T> {
    case success(result: T)
    case failure(error: Error)
}
