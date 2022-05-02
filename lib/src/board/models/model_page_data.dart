class ModelPageData {
  final int totalCount;
  final int pagePerCount;
  final int pageNumCountPerPage;
  late int currentPageNum;
  late int lastPage;
  late List<int> pageNumList;

  ModelPageData({
    required int currentPageNum,
    required this.totalCount,
    required this.pagePerCount,
    required this.pageNumCountPerPage,
  }) {
    lastPage = totalCount % pagePerCount > 0
        ? (totalCount ~/ pagePerCount) + 1
        : (totalCount ~/ pagePerCount);

    this.currentPageNum = lastPage < currentPageNum ? lastPage : currentPageNum;

    pageNumList = List.generate(pageNumCountPerPage, (index) {
      var factor = this.currentPageNum ~/ (pageNumCountPerPage + 1);
      return index + 1 + (factor * pageNumCountPerPage);
    }).where((e) => e <= lastPage).toList();
  }

  bool get _isFirstPage => currentPageNum == 1;

  bool get _isLastPage => currentPageNum == lastPage;

  bool get _canPreStepPage => pageNumCountPerPage < pageNumList.first;

  bool get _canNextStepPage => pageNumList.last != lastPage;

  int? get nextPage => _isLastPage ? null : currentPageNum + 1;

  int? get prePage => _isFirstPage ? null : currentPageNum - 1;

  int? get nextStepPage =>
      _canNextStepPage ? pageNumList.first + pageNumCountPerPage : null;

  int? get preStepPage => _canPreStepPage ? pageNumList.first - 1 : null;
}
