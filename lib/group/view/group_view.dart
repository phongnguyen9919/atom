import 'package:atom/common/lazy_indexed_stack.dart';
import 'package:atom/common/t_element.dart';
import 'package:atom/common/t_fill_button.dart';
import 'package:atom/common/t_outline_button.dart';
import 'package:atom/device/view/device_page.dart';
import 'package:atom/gen/colors.gen.dart';
import 'package:atom/group/group.dart';
import 'package:atom/packages/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupView extends StatelessWidget {
  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((GroupBloc bloc) => bloc.state.selectedTab);

    return Column(
      children: [
        const _Tabbar(),
        Expanded(
            child: LazyLoadIndexedStack(
          index: selectedTab.index,
          children: const [
            GroupList(),
            DeviceList(),
          ],
        )),
      ],
    );
  }
}

class _Tabbar extends StatelessWidget {
  const _Tabbar();

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((GroupBloc bloc) => bloc.state.selectedTab);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child:
                  _TabButton(selectedTab: selectedTab, value: GroupTab.group)),
          const SizedBox(width: 16),
          Expanded(
              child:
                  _TabButton(selectedTab: selectedTab, value: GroupTab.device)),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.selectedTab,
    required this.value,
  });

  final GroupTab selectedTab;
  final GroupTab value;

  @override
  Widget build(BuildContext context) {
    if (value == selectedTab) {
      return TFillButton(onPressed: () {}, title: value.value);
    } else {
      return TOutlineButton(
          onPressed: () => context.read<GroupBloc>().add(TabChanged(value)),
          title: value.value);
    }
  }
}

class GroupList extends StatelessWidget {
  const GroupList({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final groupStream = context.read<GroupBloc>().group;

    final domain = context.select((GroupBloc bloc) => bloc.state.domain);
    final isAdmin = context.select((GroupBloc bloc) => bloc.state.isAdmin);
    final group = context.select((GroupBloc bloc) => bloc.state.group);

    return StreamBuilder(
      stream: groupStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final gr = (snapshot.data as List<dynamic>)
            .where((ele) => ele['id'] == group?.id)
            .toList();
        if (gr.isNotEmpty) {
          context.read<GroupBloc>().add(GroupChanged(Group.fromJson(gr.first)));
        }
        final data = (snapshot.data as List<dynamic>)
            .where(
                (ele) => (ele as Map<String, dynamic>)['group_id'] == group?.id)
            .toList();
        if (data.isEmpty) {
          return Center(
              child: Text('There is no groups in this location',
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ColorName.XBlack,
                  )));
        }
        return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (_, __) => Divider(
                  color: ColorName.XBlack.withAlpha(106),
                  thickness: 1.2,
                ),
            itemBuilder: (_, index) {
              final item = data[index];
              return TElement(
                title: item['name'],
                // subtitle: item['password'],
                subtitle: '',
                iconData: Icons.dns,
                onPressed: () => Navigator.of(context).push(GroupPage.route(
                  domain: domain,
                  isAdmin: isAdmin,
                  group: Group.fromJson(item),
                )),
                isAdmin: isAdmin,
                onDeletePressed: () =>
                    context.read<GroupBloc>().add(DeleteGroup(item['id'])),
              );
            });
        // Return your widget with the data from the snapshot
      },
    );
  }
}

class DeviceList extends StatelessWidget {
  const DeviceList({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final deviceStream = context.read<GroupBloc>().device;

    final domain = context.select((GroupBloc bloc) => bloc.state.domain);
    final isAdmin = context.select((GroupBloc bloc) => bloc.state.isAdmin);
    final group = context.select((GroupBloc bloc) => bloc.state.group);

    return StreamBuilder(
      stream: deviceStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = (snapshot.data as List<dynamic>)
            .where(
                (ele) => (ele as Map<String, dynamic>)['group_id'] == group?.id)
            .toList();
        if (data.isEmpty) {
          return Center(
              child: Text('There is no devices in this location',
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ColorName.XBlack,
                  )));
        }
        return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (_, __) => Divider(
                  color: ColorName.XBlack.withAlpha(106),
                  thickness: 1.2,
                ),
            itemBuilder: (_, index) {
              final item = data[index];
              return TElement(
                  title: item['name'],
                  // subtitle: item['password'],
                  subtitle: '',
                  iconData: Icons.sensors,
                  isAdmin: isAdmin,
                  onDeletePressed: () =>
                      context.read<GroupBloc>().add(DeleteDevice(item['id'])),
                  onPressed: () => Navigator.of(context).push(DevicePage.route(
                        domain: domain,
                        device: Device.fromJson(item),
                        isAdmin: isAdmin,
                      )));
            });
        // Return your widget with the data from the snapshot
      },
    );
  }
}
