part of 'group_bloc.dart';

enum GroupTab {
  group('Group'),
  device('Device');

  const GroupTab(this.value);

  final String value;
}

class GroupState extends Equatable {
  const GroupState({
    required this.group,
    this.domain = '',
    this.selectedTab = GroupTab.group,
    this.isAdmin = false,
  });

  final String domain;
  final GroupTab selectedTab;
  final bool isAdmin;
  final Group? group;

  @override
  List<Object?> get props => [domain, selectedTab, isAdmin, group];

  GroupState copyWith({
    String? domain,
    GroupTab? selectedTab,
    bool? isAdmin,
    Group? group,
  }) {
    return GroupState(
      domain: domain ?? this.domain,
      selectedTab: selectedTab ?? this.selectedTab,
      isAdmin: isAdmin ?? this.isAdmin,
      group: group ?? this.group,
    );
  }
}
