part of 'member_bloc.dart';

class MemberState extends Equatable {
  const MemberState({
    this.domain = '',
    this.isAdmin = false,
  });

  final String domain;
  final bool isAdmin;

  @override
  List<Object> get props => [domain, isAdmin];

  MemberState copyWith({
    String? domain,
    bool? isAdmin,
  }) {
    return MemberState(
      domain: domain ?? this.domain,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
