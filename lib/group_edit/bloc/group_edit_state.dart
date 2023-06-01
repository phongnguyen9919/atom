part of 'group_edit_bloc.dart';

enum GroupEditStatus {
  normal,
  waiting,
  success,
  failure,
}

extension GroupEditStatusX on GroupEditStatus {
  bool isWaiting() => this == GroupEditStatus.waiting;
  bool isSuccess() => this == GroupEditStatus.success;
  bool isFailure() => this == GroupEditStatus.failure;
}

class GroupEditState extends Equatable {
  const GroupEditState({
    required this.isAdmin,
    required this.domain,
    required this.parentId,
    this.status = GroupEditStatus.normal,
    required this.isEdit,
    this.name = '',
    this.initialId,
    this.error,
  });

  // immute
  final bool isAdmin;
  final String domain;
  final String? parentId;

  // initial
  final String? initialId;

  // input
  final String name;

  // status
  final GroupEditStatus status;
  final bool isEdit;
  final String? error;

  @override
  List<Object?> get props =>
      [isAdmin, domain, parentId, isEdit, initialId, name, status, error];

  GroupEditState copyWith({
    bool? isAdmin,
    String? domain,
    String? parentId,
    String? name,
    bool? isEdit,
    GroupEditStatus? status,
    String? initialId,
    String? Function()? error,
  }) {
    return GroupEditState(
      isAdmin: isAdmin ?? this.isAdmin,
      domain: domain ?? this.domain,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      isEdit: isEdit ?? this.isEdit,
      status: status ?? this.status,
      initialId: initialId ?? this.initialId,
      error: error != null ? error() : this.error,
    );
  }
}
