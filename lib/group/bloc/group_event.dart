part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class TabChanged extends GroupEvent {
  const TabChanged(this.tab);

  final GroupTab tab;

  @override
  List<Object> get props => [tab];
}

class GroupChanged extends GroupEvent {
  const GroupChanged(this.group);

  final Group group;

  @override
  List<Object> get props => [group];
}

class DeleteGroup extends GroupEvent {
  const DeleteGroup(this.groupId);

  final String groupId;

  @override
  List<Object> get props => [groupId];
}

class DeleteDevice extends GroupEvent {
  const DeleteDevice(this.deviceId);

  final String deviceId;

  @override
  List<Object> get props => [deviceId];
}
