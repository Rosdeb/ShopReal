
String? _str(dynamic v) => v == null ? null : v.toString();

int? _int(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

double? _double(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

bool? _bool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is String) return v.toLowerCase() == 'true';
  return null;
}

DateTime? _date(dynamic v) {
  if (v == null) return null;
  if (v is String) return DateTime.tryParse(v);
  return null;
}

List<String> _strList(dynamic v) {
  if (v == null) return const [];
  if (v is List) return v.map((e) => e.toString()).toList();
  return const [];
}

Map<String, dynamic>? _map(dynamic v) {
  if (v is Map) return Map<String, dynamic>.from(v);
  return null;
}

List<T> _list<T>(dynamic v, T Function(Map<String, dynamic>) fromJson) {
  if (v is! List) return const [];
  return v
      .whereType<Map>()
      .map((e) => fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

// ---------------------------------------------------------------------------
// Top-level envelope
// ---------------------------------------------------------------------------

class ProductsApiResponse {
  final bool success;
  final int status;
  final String message;
  final ProductsPayload response;

  const ProductsApiResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.response,
  });

  factory ProductsApiResponse.fromJson(Map<String, dynamic> json) {
    return ProductsApiResponse(
      success: json['success'] as bool? ?? false,
      status: _int(json['status']) ?? 0,
      message: _str(json['message']) ?? '',
      response: ProductsPayload.fromJson(_map(json['response']) ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'status': status,
    'message': message,
    'response': response.toJson(),
  };
}

class ProductsPayload {
  final List<ScannedProduct> data;
  final Pagination pagination;

  const ProductsPayload({required this.data, required this.pagination});

  factory ProductsPayload.fromJson(Map<String, dynamic> json) {
    return ProductsPayload(
      data: _list(json['data'], ScannedProduct.fromJson),
      pagination: Pagination.fromJson(_map(json['pagination']) ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'pagination': pagination.toJson(),
  };
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  const Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: _int(json['total']) ?? 0,
      page: _int(json['page']) ?? 1,
      limit: _int(json['limit']) ?? 0,
      totalPages: _int(json['totalPages']) ?? 0,
      hasNextPage: _bool(json['hasNextPage']) ?? false,
      hasPrevPage: _bool(json['hasPrevPage']) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
    'hasNextPage': hasNextPage,
    'hasPrevPage': hasPrevPage,
  };
}

// ---------------------------------------------------------------------------
// Product
// ---------------------------------------------------------------------------

class ScannedProduct {
  final String id;
  final String url;
  final String title;
  final String? description;
  final double? price;
  final double? originalPrice;
  final String currency;
  final List<String> imageUrls;
  final String? sku;
  final String? brand;
  final String? category;
  final String? storeName;
  final String? storeUrl;
  final String? domainId;
  final DateTime? lastScanned;
  final int scanCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProductDomain? domain;
  final List<ProductScan> scans;

  const ScannedProduct({
    required this.id,
    required this.url,
    required this.title,
    this.description,
    this.price,
    this.originalPrice,
    required this.currency,
    required this.imageUrls,
    this.sku,
    this.brand,
    this.category,
    this.storeName,
    this.storeUrl,
    this.domainId,
    this.lastScanned,
    required this.scanCount,
    this.createdAt,
    this.updatedAt,
    this.domain,
    required this.scans,
  });

  /// The most recent scan, if any (scans are assumed API-ordered; falls
  /// back to comparing createdAt if more than one is present).
  ProductScan? get latestScan {
    if (scans.isEmpty) return null;
    final sorted = [...scans]..sort((a, b) {
      final ad = a.createdAt;
      final bd = b.createdAt;
      if (ad == null || bd == null) return 0;
      return bd.compareTo(ad);
    });
    return sorted.first;
  }

  factory ScannedProduct.fromJson(Map<String, dynamic> json) {
    return ScannedProduct(
      id: _str(json['id']) ?? '',
      url: _str(json['url']) ?? '',
      title: _str(json['title']) ?? '',
      description: _str(json['description']),
      price: _double(json['price']),
      originalPrice: _double(json['originalPrice']),
      currency: _str(json['currency']) ?? 'USD',
      imageUrls: json['imageUrls'] != null ? _strList(json['imageUrls']) : _strList(json['images']),
      sku: _str(json['sku']),
      brand: _str(json['brand']),
      category: _str(json['category']),
      storeName: _str(json['storeName']),
      storeUrl: _str(json['storeUrl']),
      domainId: _str(json['domainId']),
      lastScanned: _date(json['lastScanned']),
      scanCount: _int(json['scanCount']) ?? 0,
      createdAt: _date(json['createdAt']),
      updatedAt: _date(json['updatedAt']),
      domain: (json['domain'] != null && json['domain'] is Map)
          ? ProductDomain.fromJson(_map(json['domain'])!)
          : null,
      scans: _list(json['scans'], ProductScan.fromJson),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'title': title,
    'description': description,
    'price': price,
    'originalPrice': originalPrice,
    'currency': currency,
    'imageUrls': imageUrls,
    'sku': sku,
    'brand': brand,
    'category': category,
    'storeName': storeName,
    'storeUrl': storeUrl,
    'domainId': domainId,
    'lastScanned': lastScanned?.toIso8601String(),
    'scanCount': scanCount,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'domain': domain?.toJson(),
    'scans': scans.map((e) => e.toJson()).toList(),
  };
}

// ---------------------------------------------------------------------------
// Domain / WHOIS info
// ---------------------------------------------------------------------------

class ProductDomain {
  final String id;
  final String hostname;
  final String? registrar;
  final DateTime? createdDate;
  final DateTime? expiresDate;
  final DateTime? updatedDate;
  final int? domainAgeDays;
  final int? daysUntilExpiry;
  final List<String> nameServers;
  final String? organization;
  final String? country;
  final String? whoisSource;
  final bool? whoisAvailable;
  final String? status;
  final bool sslValid;
  final bool hasPrivacyPolicy;
  final bool hasReturnPolicy;
  final bool hasContactInfo;
  final bool isBlacklisted;
  final int? trustScore;
  final DateTime? lastChecked;
  final int checkCount;
  final Map<String, dynamic>? meta;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductDomain({
    required this.id,
    required this.hostname,
    this.registrar,
    this.createdDate,
    this.expiresDate,
    this.updatedDate,
    this.domainAgeDays,
    this.daysUntilExpiry,
    required this.nameServers,
    this.organization,
    this.country,
    this.whoisSource,
    this.whoisAvailable,
    this.status,
    required this.sslValid,
    required this.hasPrivacyPolicy,
    required this.hasReturnPolicy,
    required this.hasContactInfo,
    required this.isBlacklisted,
    this.trustScore,
    this.lastChecked,
    required this.checkCount,
    this.meta,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductDomain.fromJson(Map<String, dynamic> json) {
    return ProductDomain(
      id: _str(json['id']) ?? '',
      hostname: _str(json['hostname']) ?? '',
      registrar: _str(json['registrar']),
      createdDate: _date(json['createdDate']),
      expiresDate: _date(json['expiresDate']),
      updatedDate: _date(json['updatedDate']),
      domainAgeDays: _int(json['domainAgeDays']),
      daysUntilExpiry: _int(json['daysUntilExpiry']),
      nameServers: _strList(json['nameServers']),
      organization: _str(json['organization']),
      country: _str(json['country']),
      whoisSource: _str(json['whoisSource']),
      whoisAvailable: _bool(json['whoisAvailable']),
      status: _str(json['status']),
      sslValid: _bool(json['sslValid']) ?? false,
      hasPrivacyPolicy: _bool(json['hasPrivacyPolicy']) ?? false,
      hasReturnPolicy: _bool(json['hasReturnPolicy']) ?? false,
      hasContactInfo: _bool(json['hasContactInfo']) ?? false,
      isBlacklisted: _bool(json['isBlacklisted']) ?? false,
      trustScore: _int(json['trustScore']),
      lastChecked: _date(json['lastChecked']),
      checkCount: _int(json['checkCount']) ?? 0,
      meta: _map(json['meta']),
      createdAt: _date(json['createdAt']),
      updatedAt: _date(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'hostname': hostname,
    'registrar': registrar,
    'createdDate': createdDate?.toIso8601String(),
    'expiresDate': expiresDate?.toIso8601String(),
    'updatedDate': updatedDate?.toIso8601String(),
    'domainAgeDays': domainAgeDays,
    'daysUntilExpiry': daysUntilExpiry,
    'nameServers': nameServers,
    'organization': organization,
    'country': country,
    'whoisSource': whoisSource,
    'whoisAvailable': whoisAvailable,
    'status': status,
    'sslValid': sslValid,
    'hasPrivacyPolicy': hasPrivacyPolicy,
    'hasReturnPolicy': hasReturnPolicy,
    'hasContactInfo': hasContactInfo,
    'isBlacklisted': isBlacklisted,
    'trustScore': trustScore,
    'lastChecked': lastChecked?.toIso8601String(),
    'checkCount': checkCount,
    'meta': meta,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

// ---------------------------------------------------------------------------
// Scan
// ---------------------------------------------------------------------------

enum ScanStatus { completed, processing, failed, unknown }

ScanStatus _scanStatusFromString(String? v) {
  switch (v) {
    case 'completed':
      return ScanStatus.completed;
    case 'processing':
      return ScanStatus.processing;
    case 'failed':
      return ScanStatus.failed;
    default:
      return ScanStatus.unknown;
  }
}

enum ScanVerdict { legitimate, counterfeitRisk, scam, unknown }

ScanVerdict _verdictFromString(String? v) {
  switch (v) {
    case 'legitimate':
      return ScanVerdict.legitimate;
    case 'counterfeit_risk':
      return ScanVerdict.counterfeitRisk;
    case 'scam':
      return ScanVerdict.scam;
    default:
      return ScanVerdict.unknown;
  }
}

class ProductScan {
  final String id;
  final String productId;
  final String userId;
  final ScanStatus status;
  final ScanVerdict? verdict;
  final int? confidenceScore;
  final double? dropshipProbability;
  final ScanSignals signals;
  final List<dynamic> aliexpressMatches;
  final List<dynamic> amazonMatches;
  final List<dynamic> otherMatches;
  final double? priceMarkup;
  final double? sourcePrice;
  final String? sourcePlatform;
  final String? aiSummary;
  final List<String> riskFactors;
  final int? scanDuration;
  final String? rulesVersion;
  final DateTime? createdAt;

  const ProductScan({
    required this.id,
    required this.productId,
    required this.userId,
    required this.status,
    this.verdict,
    this.confidenceScore,
    this.dropshipProbability,
    required this.signals,
    required this.aliexpressMatches,
    required this.amazonMatches,
    required this.otherMatches,
    this.priceMarkup,
    this.sourcePrice,
    this.sourcePlatform,
    this.aiSummary,
    required this.riskFactors,
    this.scanDuration,
    this.rulesVersion,
    this.createdAt,
  });

  factory ProductScan.fromJson(Map<String, dynamic> json) {
    return ProductScan(
      id: _str(json['id']) ?? '',
      productId: _str(json['productId']) ?? '',
      userId: _str(json['userId']) ?? '',
      status: _scanStatusFromString(_str(json['status'])),
      verdict: json['verdict'] == null
          ? null
          : _verdictFromString(_str(json['verdict'])),
      confidenceScore: _int(json['confidenceScore']),
      dropshipProbability: _double(json['dropshipProbability']),
      signals: ScanSignals.fromJson(_map(json['signals']) ?? const {}),
      aliexpressMatches: (json['aliexpressMatches'] as List?) ?? const [],
      amazonMatches: (json['amazonMatches'] as List?) ?? const [],
      otherMatches: (json['otherMatches'] as List?) ?? const [],
      priceMarkup: _double(json['priceMarkup']),
      sourcePrice: _double(json['sourcePrice']),
      sourcePlatform: _str(json['sourcePlatform']),
      aiSummary: _str(json['aiSummary']),
      riskFactors: _strList(json['riskFactors']),
      scanDuration: _int(json['scanDuration']),
      rulesVersion: _str(json['rulesVersion']),
      createdAt: _date(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'userId': userId,
    'status': status.name,
    'verdict': verdict?.name,
    'confidenceScore': confidenceScore,
    'dropshipProbability': dropshipProbability,
    'signals': signals.toJson(),
    'aliexpressMatches': aliexpressMatches,
    'amazonMatches': amazonMatches,
    'otherMatches': otherMatches,
    'priceMarkup': priceMarkup,
    'sourcePrice': sourcePrice,
    'sourcePlatform': sourcePlatform,
    'aiSummary': aiSummary,
    'riskFactors': riskFactors,
    'scanDuration': scanDuration,
    'rulesVersion': rulesVersion,
    'createdAt': createdAt?.toIso8601String(),
  };
}

// ---------------------------------------------------------------------------
// Scan signals (nested, per-source breakdown)
// ---------------------------------------------------------------------------

class ScanSignals {
  final AiSignal? ai;
  final HardSignal? hard;
  final IngestionSignal? ingestion;
  final DomainTrustSignal? domainTrust;
  final MarketplaceSignal? marketplace;
  final SourceBreakdown? sourceBreakdown;
  final String? error;

  const ScanSignals({
    this.ai,
    this.hard,
    this.ingestion,
    this.domainTrust,
    this.marketplace,
    this.sourceBreakdown,
    this.error,
  });

  factory ScanSignals.fromJson(Map<String, dynamic> json) {
    return ScanSignals(
      ai: json['ai'] == null ? null : AiSignal.fromJson(_map(json['ai'])!),
      hard: json['hard'] == null
          ? null
          : HardSignal.fromJson(_map(json['hard'])!),
      ingestion: json['ingestion'] == null
          ? null
          : IngestionSignal.fromJson(_map(json['ingestion'])!),
      domainTrust: json['domainTrust'] == null
          ? null
          : DomainTrustSignal.fromJson(_map(json['domainTrust'])!),
      marketplace: json['marketplace'] == null
          ? null
          : MarketplaceSignal.fromJson(_map(json['marketplace'])!),
      sourceBreakdown: json['sourceBreakdown'] == null
          ? null
          : SourceBreakdown.fromJson(_map(json['sourceBreakdown'])!),
      error: _str(json['error']),
    );
  }

  Map<String, dynamic> toJson() => {
    if (ai != null) 'ai': ai!.toJson(),
    if (hard != null) 'hard': hard!.toJson(),
    if (ingestion != null) 'ingestion': ingestion!.toJson(),
    if (domainTrust != null) 'domainTrust': domainTrust!.toJson(),
    if (marketplace != null) 'marketplace': marketplace!.toJson(),
    if (sourceBreakdown != null)
      'sourceBreakdown': sourceBreakdown!.toJson(),
    if (error != null) 'error': error,
  };
}

class BrandAnalysis {
  final bool hasBrand;
  final String? brandName;
  final String? brandLegitimacy;

  const BrandAnalysis({
    required this.hasBrand,
    this.brandName,
    this.brandLegitimacy,
  });

  factory BrandAnalysis.fromJson(Map<String, dynamic> json) {
    return BrandAnalysis(
      hasBrand: _bool(json['hasBrand']) ?? false,
      brandName: _str(json['brandName']),
      brandLegitimacy: _str(json['brandLegitimacy']),
    );
  }

  Map<String, dynamic> toJson() => {
    'hasBrand': hasBrand,
    'brandName': brandName,
    'brandLegitimacy': brandLegitimacy,
  };
}

class AiSignal {
  final String? source;
  final bool aiAvailable;
  final String? explanation;
  final double? aiConfidence;
  final BrandAnalysis? brandAnalysis;
  final bool genericBranding;
  final bool legitimateBrand;
  final bool supplierLanguage;
  final bool suspiciousDomain;
  final bool massMarketProduct;
  final bool professionalStore;

  const AiSignal({
    this.source,
    required this.aiAvailable,
    this.explanation,
    this.aiConfidence,
    this.brandAnalysis,
    required this.genericBranding,
    required this.legitimateBrand,
    required this.supplierLanguage,
    required this.suspiciousDomain,
    required this.massMarketProduct,
    required this.professionalStore,
  });

  factory AiSignal.fromJson(Map<String, dynamic> json) {
    return AiSignal(
      source: _str(json['source']),
      aiAvailable: _bool(json['aiAvailable']) ?? false,
      explanation: _str(json['explanation']),
      aiConfidence: _double(json['aiConfidence']),
      brandAnalysis: json['brandAnalysis'] == null
          ? null
          : BrandAnalysis.fromJson(_map(json['brandAnalysis'])!),
      genericBranding: _bool(json['genericBranding']) ?? false,
      legitimateBrand: _bool(json['legitimateBrand']) ?? false,
      supplierLanguage: _bool(json['supplierLanguage']) ?? false,
      suspiciousDomain: _bool(json['suspiciousDomain']) ?? false,
      massMarketProduct: _bool(json['massMarketProduct']) ?? false,
      professionalStore: _bool(json['professionalStore']) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'source': source,
    'aiAvailable': aiAvailable,
    'explanation': explanation,
    'aiConfidence': aiConfidence,
    'brandAnalysis': brandAnalysis?.toJson(),
    'genericBranding': genericBranding,
    'legitimateBrand': legitimateBrand,
    'supplierLanguage': supplierLanguage,
    'suspiciousDomain': suspiciousDomain,
    'massMarketProduct': massMarketProduct,
    'professionalStore': professionalStore,
  };
}

class HardSignal {
  final bool isShopify;
  final bool youngDomain;
  final bool genericTitle;
  final bool hasBrandInfo;
  final bool longShipping;
  final bool noReturnPolicy;
  final bool supplierLanguage;
  final bool suspiciousImages;
  final bool priceLooksInflated;

  const HardSignal({
    required this.isShopify,
    required this.youngDomain,
    required this.genericTitle,
    required this.hasBrandInfo,
    required this.longShipping,
    required this.noReturnPolicy,
    required this.supplierLanguage,
    required this.suspiciousImages,
    required this.priceLooksInflated,
  });

  factory HardSignal.fromJson(Map<String, dynamic> json) {
    return HardSignal(
      isShopify: _bool(json['isShopify']) ?? false,
      youngDomain: _bool(json['youngDomain']) ?? false,
      genericTitle: _bool(json['genericTitle']) ?? false,
      hasBrandInfo: _bool(json['hasBrandInfo']) ?? false,
      longShipping: _bool(json['longShipping']) ?? false,
      noReturnPolicy: _bool(json['noReturnPolicy']) ?? false,
      supplierLanguage: _bool(json['supplierLanguage']) ?? false,
      suspiciousImages: _bool(json['suspiciousImages']) ?? false,
      priceLooksInflated: _bool(json['priceLooksInflated']) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'isShopify': isShopify,
    'youngDomain': youngDomain,
    'genericTitle': genericTitle,
    'hasBrandInfo': hasBrandInfo,
    'longShipping': longShipping,
    'noReturnPolicy': noReturnPolicy,
    'supplierLanguage': supplierLanguage,
    'suspiciousImages': suspiciousImages,
    'priceLooksInflated': priceLooksInflated,
  };
}

class PlatformDetection {
  final String? reason;
  final bool confirmed;
  final bool isShopifyCandidate;

  const PlatformDetection({
    this.reason,
    required this.confirmed,
    required this.isShopifyCandidate,
  });

  factory PlatformDetection.fromJson(Map<String, dynamic> json) {
    return PlatformDetection(
      reason: _str(json['reason']),
      confirmed: _bool(json['confirmed']) ?? false,
      isShopifyCandidate: _bool(json['isShopifyCandidate']) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'reason': reason,
    'confirmed': confirmed,
    'isShopifyCandidate': isShopifyCandidate,
  };
}

class IngestionSignal {
  final String? dataSource;
  final String? sourcePath;
  final String? blockedReason;
  final PlatformDetection? platformDetection;
  final String? extractionConfidence;

  const IngestionSignal({
    this.dataSource,
    this.sourcePath,
    this.blockedReason,
    this.platformDetection,
    this.extractionConfidence,
  });

  factory IngestionSignal.fromJson(Map<String, dynamic> json) {
    return IngestionSignal(
      dataSource: _str(json['dataSource']),
      sourcePath: _str(json['sourcePath']),
      blockedReason: _str(json['blockedReason']),
      platformDetection: json['platformDetection'] == null
          ? null
          : PlatformDetection.fromJson(_map(json['platformDetection'])!),
      extractionConfidence: _str(json['extractionConfidence']),
    );
  }

  Map<String, dynamic> toJson() => {
    'dataSource': dataSource,
    'sourcePath': sourcePath,
    'blockedReason': blockedReason,
    'platformDetection': platformDetection?.toJson(),
    'extractionConfidence': extractionConfidence,
  };
}

class DomainTrustSignal {
  final int? score;

  const DomainTrustSignal({this.score});

  factory DomainTrustSignal.fromJson(Map<String, dynamic> json) {
    return DomainTrustSignal(score: _int(json['score']));
  }

  Map<String, dynamic> toJson() => {'score': score};
}

class MarketplaceBestSource {
  final String? url;
  final double? price;
  final String? platform;

  const MarketplaceBestSource({this.url, this.price, this.platform});

  factory MarketplaceBestSource.fromJson(Map<String, dynamic> json) {
    return MarketplaceBestSource(
      url: _str(json['url']),
      price: _double(json['price']),
      platform: _str(json['platform']),
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'price': price,
    'platform': platform,
  };
}

class MarketplaceSignal {
  final MarketplaceBestSource? bestSource;
  final double? priceMarkup;
  final String? sourcePlatform;
  final int tinyeyeMatches;
  final int marketplaceCount;

  const MarketplaceSignal({
    this.bestSource,
    this.priceMarkup,
    this.sourcePlatform,
    required this.tinyeyeMatches,
    required this.marketplaceCount,
  });

  factory MarketplaceSignal.fromJson(Map<String, dynamic> json) {
    return MarketplaceSignal(
      bestSource: json['bestSource'] == null
          ? null
          : MarketplaceBestSource.fromJson(_map(json['bestSource'])!),
      priceMarkup: _double(json['priceMarkup']),
      sourcePlatform: _str(json['sourcePlatform']),
      tinyeyeMatches: _int(json['tinyeyeMatches']) ?? 0,
      marketplaceCount: _int(json['marketplaceCount']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'bestSource': bestSource?.toJson(),
    'priceMarkup': priceMarkup,
    'sourcePlatform': sourcePlatform,
    'tinyeyeMatches': tinyeyeMatches,
    'marketplaceCount': marketplaceCount,
  };
}

class SourceBreakdown {
  final int ai;
  final int rules;

  const SourceBreakdown({required this.ai, required this.rules});

  factory SourceBreakdown.fromJson(Map<String, dynamic> json) {
    return SourceBreakdown(
      ai: _int(json['ai']) ?? 0,
      rules: _int(json['rules']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'ai': ai, 'rules': rules};
}

class PriceHistoryItem {
  final String date;
  final double price;
  final String currency;
  final DateTime fetchedAt;

  const PriceHistoryItem({
    required this.date,
    required this.price,
    required this.currency,
    required this.fetchedAt,
  });

  factory PriceHistoryItem.fromJson(Map<String, dynamic> json) {
    return PriceHistoryItem(
      date: _str(json['date']) ?? '',
      price: _double(json['price']) ?? 0.0,
      currency: _str(json['currency']) ?? 'USD',
      fetchedAt: _date(json['fetchedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'price': price,
    'currency': currency,
    'fetchedAt': fetchedAt.toIso8601String(),
  };
}