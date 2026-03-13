import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum PlanType { free, family, business }
enum FamilyRole { none, parent, child, admin, member, freeWatcher, freeWatched }

class ChildProfile {
  final String id;
  final String name;
  final int age;
  final String avatarEmoji;
  final bool isActive;

  ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.avatarEmoji,
    this.isActive = true,
  });
}

class MemberProfile {
  final String id;
  final String name;
  final String department;
  final String avatarEmoji;
  final bool isActive;
  final DateTime joinedAt;

  MemberProfile({
    required this.id,
    required this.name,
    required this.department,
    required this.avatarEmoji,
    this.isActive = true,
    required this.joinedAt,
  });
}

class RideReport {
  final String childId;
  final String childName;
  final DateTime date;
  final Duration duration;
  final double distanceKm;
  final int safetyScore;
  final int reverseRunCount;
  final int speedWarningCount;
  final int stopSignIgnoreCount;
  final String route;

  RideReport({
    required this.childId,
    required this.childName,
    required this.date,
    required this.duration,
    required this.distanceKm,
    required this.safetyScore,
    required this.reverseRunCount,
    required this.speedWarningCount,
    required this.stopSignIgnoreCount,
    required this.route,
  });
}

/// GPS location snapshot for free plan watch
class GpsSnapshot {
  final String watchedId;
  final String watchedName;
  final double lat;
  final double lng;
  final String address;
  final DateTime timestamp;
  final bool isMoving;

  GpsSnapshot({
    required this.watchedId,
    required this.watchedName,
    required this.lat,
    required this.lng,
    required this.address,
    required this.timestamp,
    this.isMoving = false,
  });
}

class PlanProvider extends ChangeNotifier {
  PlanType _currentPlan = PlanType.free;
  FamilyRole _familyRole = FamilyRole.none;
  String _familyId = '';
  String _orgName = '';
  List<ChildProfile> _children = [];
  List<MemberProfile> _members = [];
  List<RideReport> _rideReports = [];
  List<GpsSnapshot> _gpsSnapshots = [];
  String _watchedName = '';

  PlanType get currentPlan => _currentPlan;
  FamilyRole get familyRole => _familyRole;
  String get familyId => _familyId;
  String get orgName => _orgName;
  List<ChildProfile> get children => _children;
  List<MemberProfile> get members => _members;
  List<RideReport> get rideReports => _rideReports;
  List<GpsSnapshot> get gpsSnapshots => _gpsSnapshots;
  String get watchedName => _watchedName;
  bool get isFamilyPlan => _currentPlan == PlanType.family;
  bool get isBusinessPlan => _currentPlan == PlanType.business;
  bool get isFreePlan => _currentPlan == PlanType.free;
  bool get isPaidPlan => _currentPlan != PlanType.free;
  bool get isParent => _familyRole == FamilyRole.parent;
  bool get isChild => _familyRole == FamilyRole.child;
  bool get isAdmin => _familyRole == FamilyRole.admin;
  bool get isMember => _familyRole == FamilyRole.member;
  bool get isFreeWatcher => _familyRole == FamilyRole.freeWatcher;
  bool get isFreeWatched => _familyRole == FamilyRole.freeWatched;
  bool get hasFreeWatch => _familyRole == FamilyRole.freeWatcher || _familyRole == FamilyRole.freeWatched;

  static const int maxChildren = 5;
  static const int freeWatchLimit = 1;

  Future<void> loadPlan() async {
    final box = await Hive.openBox('plan_settings');
    final planIndex = box.get('plan_type', defaultValue: 0);
    _currentPlan = PlanType.values[planIndex];
    final roleIndex = box.get('family_role', defaultValue: 0);
    _familyRole = FamilyRole.values[roleIndex];
    _familyId = box.get('family_id', defaultValue: '');
    _orgName = box.get('org_name', defaultValue: '');
    _watchedName = box.get('watched_name', defaultValue: '');

    if (_currentPlan == PlanType.family && _familyRole == FamilyRole.parent) {
      _loadFamilyDummyData();
    } else if (_currentPlan == PlanType.business && _familyRole == FamilyRole.admin) {
      _loadBusinessDummyData();
    } else if (_currentPlan == PlanType.free && _familyRole == FamilyRole.freeWatcher) {
      _loadFreeWatchDummyData();
    }
    notifyListeners();
  }

  Future<void> upgradeToPlan(PlanType plan) async {
    _currentPlan = plan;
    final box = await Hive.openBox('plan_settings');
    await box.put('plan_type', plan.index);
    if (plan == PlanType.family && _familyRole == FamilyRole.none) {
      await setFamilyRole(FamilyRole.parent);
    } else if (plan == PlanType.family && _familyRole == FamilyRole.freeWatcher) {
      // Upgrade from free watcher to family parent
      await setFamilyRole(FamilyRole.parent);
    } else if (plan == PlanType.business && _familyRole == FamilyRole.none) {
      await setFamilyRole(FamilyRole.admin);
    }
    notifyListeners();
  }

  Future<void> downgradeToFree() async {
    _currentPlan = PlanType.free;
    _familyRole = FamilyRole.none;
    _familyId = '';
    _orgName = '';
    _watchedName = '';
    _children = [];
    _members = [];
    _rideReports = [];
    _gpsSnapshots = [];
    final box = await Hive.openBox('plan_settings');
    await box.put('plan_type', 0);
    await box.put('family_role', 0);
    await box.put('family_id', '');
    await box.put('org_name', '');
    await box.put('watched_name', '');
    notifyListeners();
  }

  Future<void> setFamilyRole(FamilyRole role) async {
    _familyRole = role;
    final box = await Hive.openBox('plan_settings');
    await box.put('family_role', role.index);
    if ((role == FamilyRole.parent || role == FamilyRole.admin) && _familyId.isEmpty) {
      _familyId = role == FamilyRole.admin ? _generateBusinessId() : _generateFamilyId();
      await box.put('family_id', _familyId);
      if (role == FamilyRole.parent) {
        _loadFamilyDummyData();
      } else {
        _loadBusinessDummyData();
      }
    }
    if (role == FamilyRole.freeWatcher && _familyId.isEmpty) {
      _familyId = _generateFreeWatchId();
      await box.put('family_id', _familyId);
      _loadFreeWatchDummyData();
    }
    notifyListeners();
  }

  Future<void> setupFreeWatch(String watchedPersonName) async {
    _currentPlan = PlanType.free;
    _familyRole = FamilyRole.freeWatcher;
    _watchedName = watchedPersonName;
    _familyId = _generateFreeWatchId();
    final box = await Hive.openBox('plan_settings');
    await box.put('plan_type', PlanType.free.index);
    await box.put('family_role', FamilyRole.freeWatcher.index);
    await box.put('family_id', _familyId);
    await box.put('watched_name', watchedPersonName);
    _loadFreeWatchDummyData();
    notifyListeners();
  }

  Future<void> joinFreeWatch(String watchId) async {
    _familyId = watchId;
    _familyRole = FamilyRole.freeWatched;
    final box = await Hive.openBox('plan_settings');
    await box.put('family_id', watchId);
    await box.put('family_role', FamilyRole.freeWatched.index);
    notifyListeners();
  }

  Future<void> cancelFreeWatch() async {
    _familyRole = FamilyRole.none;
    _familyId = '';
    _watchedName = '';
    _gpsSnapshots = [];
    final box = await Hive.openBox('plan_settings');
    await box.put('family_role', 0);
    await box.put('family_id', '');
    await box.put('watched_name', '');
    notifyListeners();
  }

  Future<void> setOrgName(String name) async {
    _orgName = name;
    final box = await Hive.openBox('plan_settings');
    await box.put('org_name', name);
    notifyListeners();
  }

  Future<void> joinFamily(String familyId) async {
    _familyId = familyId;
    _familyRole = FamilyRole.child;
    final box = await Hive.openBox('plan_settings');
    await box.put('family_id', familyId);
    await box.put('family_role', FamilyRole.child.index);
    notifyListeners();
  }

  Future<void> joinBusiness(String orgId) async {
    _familyId = orgId;
    _familyRole = FamilyRole.member;
    final box = await Hive.openBox('plan_settings');
    await box.put('family_id', orgId);
    await box.put('family_role', FamilyRole.member.index);
    notifyListeners();
  }

  String _generateFamilyId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final now = DateTime.now().millisecondsSinceEpoch;
    String id = 'CHARI-';
    for (int i = 0; i < 4; i++) {
      id += chars[(now + i * 7) % chars.length];
    }
    return id;
  }

  String _generateBusinessId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final now = DateTime.now().millisecondsSinceEpoch;
    String id = 'BIZ-';
    for (int i = 0; i < 6; i++) {
      id += chars[(now + i * 11) % chars.length];
    }
    return id;
  }

  String _generateFreeWatchId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final now = DateTime.now().millisecondsSinceEpoch;
    String id = 'WATCH-';
    for (int i = 0; i < 4; i++) {
      id += chars[(now + i * 13) % chars.length];
    }
    return id;
  }

  void _loadFreeWatchDummyData() {
    if (_watchedName.isEmpty) _watchedName = '\u3086\u3044';
    _gpsSnapshots = [
      GpsSnapshot(
        watchedId: 'free_watch_001',
        watchedName: _watchedName,
        lat: 35.6594,
        lng: 139.7005,
        address: '\u6771\u4eac\u90fd\u6e0b\u8c37\u533a\u795e\u5bae\u524d5-XX',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        isMoving: true,
      ),
      GpsSnapshot(
        watchedId: 'free_watch_001',
        watchedName: _watchedName,
        lat: 35.6612,
        lng: 139.7038,
        address: '\u6771\u4eac\u90fd\u6e0b\u8c37\u533a\u5343\u99c4\u30f6\u8c371-XX',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        isMoving: true,
      ),
      GpsSnapshot(
        watchedId: 'free_watch_001',
        watchedName: _watchedName,
        lat: 35.6580,
        lng: 139.6982,
        address: '\u6771\u4eac\u90fd\u6e0b\u8c37\u533a\u4ee3\u3005\u6728\u795e\u5712\u753a15-XX',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isMoving: false,
      ),
      GpsSnapshot(
        watchedId: 'free_watch_001',
        watchedName: _watchedName,
        lat: 35.6567,
        lng: 139.6955,
        address: '\u6771\u4eac\u90fd\u6e0b\u8c37\u533a\u795e\u53571-XX\uff08\u81ea\u5b85\uff09',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isMoving: false,
      ),
    ];
  }

  void _loadFamilyDummyData() {
    _children = [
      ChildProfile(id: 'child_001', name: '\u3086\u3044', age: 10, avatarEmoji: '\u{1F467}'),
      ChildProfile(id: 'child_002', name: '\u306f\u308b\u3068', age: 14, avatarEmoji: '\u{1F466}'),
    ];
    _rideReports = [
      RideReport(childId: 'child_001', childName: '\u3086\u3044', date: DateTime.now().subtract(const Duration(hours: 3)), duration: const Duration(minutes: 25), distanceKm: 3.2, safetyScore: 72, reverseRunCount: 1, speedWarningCount: 0, stopSignIgnoreCount: 2, route: '\u5b66\u6821 \u2192 \u81ea\u5b85'),
      RideReport(childId: 'child_001', childName: '\u3086\u3044', date: DateTime.now().subtract(const Duration(days: 1)), duration: const Duration(minutes: 18), distanceKm: 2.1, safetyScore: 85, reverseRunCount: 0, speedWarningCount: 0, stopSignIgnoreCount: 1, route: '\u81ea\u5b85 \u2192 \u5b66\u6821'),
      RideReport(childId: 'child_002', childName: '\u306f\u308b\u3068', date: DateTime.now().subtract(const Duration(hours: 5)), duration: const Duration(minutes: 40), distanceKm: 8.5, safetyScore: 58, reverseRunCount: 2, speedWarningCount: 3, stopSignIgnoreCount: 1, route: '\u5b66\u6821 \u2192 \u587e \u2192 \u81ea\u5b85'),
      RideReport(childId: 'child_002', childName: '\u306f\u308b\u3068', date: DateTime.now().subtract(const Duration(days: 1, hours: 2)), duration: const Duration(minutes: 32), distanceKm: 6.8, safetyScore: 65, reverseRunCount: 1, speedWarningCount: 2, stopSignIgnoreCount: 0, route: '\u81ea\u5b85 \u2192 \u53cb\u9054\u306e\u5bb6'),
    ];
  }

  void _loadBusinessDummyData() {
    if (_orgName.isEmpty) _orgName = '\u682a\u5f0f\u4f1a\u793e\u30b5\u30f3\u30d7\u30eb\u7269\u6d41';
    _members = [
      MemberProfile(id: 'emp_001', name: '\u7530\u4e2d \u592a\u90ce', department: '\u914d\u9001\u90e8', avatarEmoji: '\u{1F468}\u{200D}\u{1F4BC}', joinedAt: DateTime.now().subtract(const Duration(days: 90))),
      MemberProfile(id: 'emp_002', name: '\u4f50\u85e4 \u82b1\u5b50', department: '\u914d\u9001\u90e8', avatarEmoji: '\u{1F469}\u{200D}\u{1F4BC}', joinedAt: DateTime.now().subtract(const Duration(days: 60))),
      MemberProfile(id: 'emp_003', name: '\u9234\u6728 \u4e00\u90ce', department: '\u55b6\u696d\u90e8', avatarEmoji: '\u{1F468}\u{200D}\u{1F4BC}', joinedAt: DateTime.now().subtract(const Duration(days: 45))),
      MemberProfile(id: 'emp_004', name: '\u9ad8\u6a4b \u7f8e\u6708', department: '\u55b6\u696d\u90e8', avatarEmoji: '\u{1F469}\u{200D}\u{1F4BC}', joinedAt: DateTime.now().subtract(const Duration(days: 30))),
      MemberProfile(id: 'emp_005', name: '\u5c71\u672c \u5065', department: '\u7dcf\u52d9\u90e8', avatarEmoji: '\u{1F468}\u{200D}\u{1F4BC}', joinedAt: DateTime.now().subtract(const Duration(days: 20))),
      MemberProfile(id: 'emp_006', name: '\u4e2d\u6751 \u3055\u304f\u3089', department: '\u914d\u9001\u90e8', avatarEmoji: '\u{1F469}\u{200D}\u{1F4BC}', joinedAt: DateTime.now().subtract(const Duration(days: 10))),
      MemberProfile(id: 'emp_007', name: '\u5c0f\u6797 \u7950\u4ecb', department: '\u914d\u9001\u90e8', avatarEmoji: '\u{1F468}\u{200D}\u{1F4BC}', joinedAt: DateTime.now().subtract(const Duration(days: 5))),
    ];
    _rideReports = [
      RideReport(childId: 'emp_001', childName: '\u7530\u4e2d \u592a\u90ce', date: DateTime.now().subtract(const Duration(hours: 2)), duration: const Duration(minutes: 55), distanceKm: 12.3, safetyScore: 91, reverseRunCount: 0, speedWarningCount: 0, stopSignIgnoreCount: 1, route: '\u5009\u5eab \u2192 \u6e0b\u8c37\u5e97 \u2192 \u5009\u5eab'),
      RideReport(childId: 'emp_002', childName: '\u4f50\u85e4 \u82b1\u5b50', date: DateTime.now().subtract(const Duration(hours: 3)), duration: const Duration(minutes: 42), distanceKm: 8.7, safetyScore: 88, reverseRunCount: 0, speedWarningCount: 1, stopSignIgnoreCount: 0, route: '\u5009\u5eab \u2192 \u65b0\u5bbf\u5e97 \u2192 \u5009\u5eab'),
      RideReport(childId: 'emp_003', childName: '\u9234\u6728 \u4e00\u90ce', date: DateTime.now().subtract(const Duration(hours: 4)), duration: const Duration(minutes: 35), distanceKm: 6.2, safetyScore: 67, reverseRunCount: 1, speedWarningCount: 2, stopSignIgnoreCount: 1, route: '\u30aa\u30d5\u30a3\u30b9 \u2192 \u5f97\u610f\u5148A \u2192 \u5f97\u610f\u5148B'),
      RideReport(childId: 'emp_004', childName: '\u9ad8\u6a4b \u7f8e\u6708', date: DateTime.now().subtract(const Duration(hours: 5)), duration: const Duration(minutes: 28), distanceKm: 5.1, safetyScore: 95, reverseRunCount: 0, speedWarningCount: 0, stopSignIgnoreCount: 0, route: '\u30aa\u30d5\u30a3\u30b9 \u2192 \u5f97\u610f\u5148C'),
      RideReport(childId: 'emp_001', childName: '\u7530\u4e2d \u592a\u90ce', date: DateTime.now().subtract(const Duration(days: 1)), duration: const Duration(minutes: 48), distanceKm: 10.5, safetyScore: 82, reverseRunCount: 0, speedWarningCount: 1, stopSignIgnoreCount: 1, route: '\u5009\u5eab \u2192 \u54c1\u5ddd\u5e97 \u2192 \u5009\u5eab'),
      RideReport(childId: 'emp_005', childName: '\u5c71\u672c \u5065', date: DateTime.now().subtract(const Duration(days: 1, hours: 1)), duration: const Duration(minutes: 20), distanceKm: 3.8, safetyScore: 78, reverseRunCount: 1, speedWarningCount: 0, stopSignIgnoreCount: 1, route: '\u30aa\u30d5\u30a3\u30b9 \u2192 \u90f5\u4fbf\u5c40 \u2192 \u30aa\u30d5\u30a3\u30b9'),
    ];
  }

  List<RideReport> getReportsForChild(String childId) {
    return _rideReports.where((r) => r.childId == childId).toList();
  }

  List<RideReport> getReportsForMember(String memberId) {
    return _rideReports.where((r) => r.childId == memberId).toList();
  }

  int getAverageSafetyScore(String id) {
    final reports = _rideReports.where((r) => r.childId == id).toList();
    if (reports.isEmpty) return 0;
    final total = reports.fold<int>(0, (sum, r) => sum + r.safetyScore);
    return (total / reports.length).round();
  }

  int getOrgAverageSafetyScore() {
    if (_rideReports.isEmpty) return 0;
    final total = _rideReports.fold<int>(0, (sum, r) => sum + r.safetyScore);
    return (total / _rideReports.length).round();
  }

  Map<String, int> getDepartmentStats() {
    final Map<String, List<int>> deptScores = {};
    for (final member in _members) {
      final reports = getReportsForMember(member.id);
      if (reports.isNotEmpty) {
        deptScores.putIfAbsent(member.department, () => []);
        for (final r in reports) {
          deptScores[member.department]!.add(r.safetyScore);
        }
      }
    }
    return deptScores.map((dept, scores) =>
        MapEntry(dept, (scores.fold<int>(0, (s, v) => s + v) / scores.length).round()));
  }

  String getPlanName() {
    switch (_currentPlan) {
      case PlanType.free:
        return '\u7121\u6599\u30d7\u30e9\u30f3';
      case PlanType.family:
        return '\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3';
      case PlanType.business:
        return '\u6cd5\u4eba\u30d7\u30e9\u30f3';
    }
  }

  String getPlanPrice() {
    switch (_currentPlan) {
      case PlanType.free:
        return '\u00a50';
      case PlanType.family:
        return '\u00a5480/\u6708';
      case PlanType.business:
        return '\u00a53,980/\u6708';
    }
  }
}
