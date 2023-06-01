part of 'member_bloc.dart';

abstract class MemberEvent extends Equatable {
  const MemberEvent();
}

class DeleteMember extends MemberEvent {
  const DeleteMember(this.memberId);

  final String memberId;

  @override
  List<Object> get props => [memberId];
}
