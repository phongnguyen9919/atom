import 'package:atom/packages/user_repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc(this._userRepository,
      {required String domain, required bool isAdmin})
      : super(MemberState(domain: domain, isAdmin: isAdmin)) {
    on<DeleteMember>(_onDeleteMember);
  }

  final UserRepository _userRepository;

  Stream<dynamic> get member => _userRepository.member(state.domain);

  Future<void> _onDeleteMember(
      DeleteMember event, Emitter<MemberState> emit) async {
    await _userRepository.deleteUser(domain: state.domain, id: event.memberId);
  }
}
