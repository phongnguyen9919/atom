part of 'group_edit_bloc.dart';

abstract class GroupEditEvent extends Equatable {
  const GroupEditEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends GroupEditEvent {
  const Submitted();
}

class NameChanged extends GroupEditEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class IsEditChanged extends GroupEditEvent {
  const IsEditChanged({required this.isEdit});

  final bool isEdit;

  @override
  List<Object> get props => [isEdit];
}
