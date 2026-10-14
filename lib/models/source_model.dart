class HistoricalSource {
  const HistoricalSource({
    required this.title,
    required this.organization,
    this.url,
  });

  final String title;
  final String organization;
  final String? url;
}
