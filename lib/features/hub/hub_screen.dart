import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/group_standing.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// In-game home ("National Hub"): continue/play, calendar, next match, squad
/// status, and the group table, with the in-game bottom navigation.
class HubScreen extends ConsumerWidget {
  const HubScreen({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(hubDataProvider(careerId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(Routes.home),
        ),
        title: Text(
          'NATIONAL HUB',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: AppColors.primary),
            onPressed: () => _soon(context),
          ),
        ],
      ),
      bottomNavigationBar: _HubBottomNav(careerId: careerId),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load save.\n$e')),
        data: (hub) {
          if (hub == null) {
            return const Center(child: Text('Save not found.'));
          }
          final nation = hub.nations[hub.career.nationId];
          final date = DateFormat('d MMM yyyy').format(hub.career.inGameDate);
          String code(int id) => hub.nations[id]?.code ?? '??';
          String name(int id) => hub.nations[id]?.name ?? 'Unknown';

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              Row(
                children: [
                  FlagDisc(nation?.code ?? '??', size: 44),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nation?.name ?? '…',
                          style: AppTypography.headlineMedium,
                        ),
                        Text(
                          '${hub.career.managerName} · $date',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: hub.next == null ? 'Qualifying complete' : 'Continue',
                icon: Icons.play_arrow_rounded,
                onPressed: hub.next == null
                    ? null
                    : () => context.go('${Routes.match}?careerId=$careerId'),
              ),
              const SizedBox(height: AppSpacing.md),
              _CalendarStrip(
                anchor: hub.next?.date ?? hub.career.inGameDate,
                fixtureDays: {
                  for (final f in hub.fixtures) _dayOnly(f.date),
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _NextMatch(next: hub.next, code: code),
              const SizedBox(height: AppSpacing.md),
              _SquadStatus(
                rating: hub.squadRating,
                size: hub.squadSize,
                onManage: () =>
                    context.go('${Routes.tactics}?careerId=$careerId'),
              ),
              const SizedBox(height: AppSpacing.md),
              if (hub.group != null)
                _GroupTable(
                  group: hub.group!,
                  playerNationId: hub.career.nationId,
                  code: code,
                  name: name,
                ),
              const SizedBox(height: AppSpacing.lg),
              if (hub.next != null)
                Center(
                  child: TextButton(
                    onPressed: () =>
                        ref.read(seasonServiceProvider).advance(careerId),
                    child: const Text('Quick sim (skip)'),
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
            ],
          );
        },
      ),
    );
  }

  static DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Coming soon')));
  }
}

class _CalendarStrip extends StatelessWidget {
  const _CalendarStrip({required this.anchor, required this.fixtureDays});

  final DateTime anchor;
  final Set<DateTime> fixtureDays;

  @override
  Widget build(BuildContext context) {
    final start = anchor.subtract(const Duration(days: 3));
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('CALENDAR', style: AppTypography.labelMedium),
              const Spacer(),
              Text(
                DateFormat('MMM yyyy').format(anchor).toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 12,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) {
                final day = start.add(Duration(days: i));
                final isMatch = fixtureDays.contains(
                  DateTime(day.year, day.month, day.day),
                );
                final isAnchor =
                    day.year == anchor.year &&
                    day.month == anchor.month &&
                    day.day == anchor.day;
                return _DayCell(
                  day: day,
                  isMatch: isMatch,
                  highlight: isAnchor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isMatch,
    required this.highlight,
  });

  final DateTime day;
  final bool isMatch;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final color = highlight ? AppColors.primary : AppColors.onSurfaceVariant;
    return Container(
      width: 46,
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.surfaceContainerLowest,
        borderRadius: AppRadii.baseAll,
        border: Border.all(
          color: highlight ? AppColors.primary : AppColors.outlineVariant,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEE').format(day).toUpperCase(),
            style: AppTypography.labelSmall.copyWith(color: color, fontSize: 9),
          ),
          const SizedBox(height: 2),
          Text(
            '${day.day}',
            style: AppTypography.titleMedium.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMatch ? AppColors.error : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextMatch extends StatelessWidget {
  const _NextMatch({required this.next, required this.code});

  final Fixture? next;
  final String Function(int) code;

  @override
  Widget build(BuildContext context) {
    final f = next;
    if (f == null) {
      return const AppCard(
        child: Center(child: Text('No more fixtures this cycle.')),
      );
    }
    final date = DateFormat('EEE d MMM').format(f.date).toUpperCase();
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              const Text('NEXT MATCH', style: AppTypography.labelMedium),
              const Spacer(),
              Text(
                'MATCHDAY ${f.matchday}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Side(code: code(f.homeNationId)),
              Column(
                children: [
                  const Text('VS', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    date,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              _Side(code: code(f.awayNationId)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'WORLD CUP QUALIFIER',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlagDisc(code, size: 56),
        const SizedBox(height: AppSpacing.xs),
        Text(code, style: AppTypography.labelMedium),
      ],
    );
  }
}

class _SquadStatus extends StatelessWidget {
  const _SquadStatus({
    required this.rating,
    required this.size,
    required this.onManage,
  });

  final int rating;
  final int size;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SQUAD STATUS', style: AppTypography.labelMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                'Avg rating',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text('$rating', style: AppTypography.labelMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: Stack(
              children: [
                Container(height: 6, color: AppColors.surfaceContainerHighest),
                FractionallySizedBox(
                  widthFactor: (rating / 99).clamp(0.0, 1.0),
                  child: Container(height: 6, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                'Squad size',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text('$size players', style: AppTypography.labelMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Manage Team',
            icon: Icons.groups,
            onPressed: onManage,
          ),
        ],
      ),
    );
  }
}

class _GroupTable extends StatelessWidget {
  const _GroupTable({
    required this.group,
    required this.playerNationId,
    required this.code,
    required this.name,
  });

  final GroupTable group;
  final int playerNationId;
  final String Function(int) code;
  final String Function(int) name;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('GROUP ${group.name}', style: AppTypography.labelMedium),
          const SizedBox(height: AppSpacing.sm),
          _row('#', 'TEAM', 'P', 'GD', 'PTS', header: true),
          const Divider(),
          for (var i = 0; i < group.standings.length; i++)
            _standingRow(i + 1, group.standings[i]),
        ],
      ),
    );
  }

  Widget _standingRow(int pos, GroupStanding s) {
    final isPlayer = s.nationId == playerNationId;
    final gd = s.goalDifference;
    return Container(
      color: isPlayer ? AppColors.surfaceContainerHigh : null,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '$pos',
              style: AppTypography.labelSmall.copyWith(
                color: isPlayer
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          FlagDisc(code(s.nationId), size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name(s.nationId),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: isPlayer ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          _cell('${s.played}'),
          _cell(gd > 0 ? '+$gd' : '$gd'),
          _cell('${s.points}', emphasize: true),
        ],
      ),
    );
  }

  Widget _row(
    String a,
    String b,
    String c,
    String d,
    String e, {
    bool header = false,
  }) {
    final style = AppTypography.labelSmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return Row(
      children: [
        SizedBox(width: 20, child: Text(a, style: style)),
        const SizedBox(width: 22 + AppSpacing.sm),
        Expanded(child: Text(b, style: style)),
        _cell(c, header: true),
        _cell(d, header: true),
        _cell(e, header: true),
      ],
    );
  }

  Widget _cell(String text, {bool header = false, bool emphasize = false}) {
    return SizedBox(
      width: 34,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTypography.labelSmall.copyWith(
          color: header
              ? AppColors.onSurfaceVariant
              : (emphasize ? AppColors.primary : AppColors.onSurface),
          fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _HubBottomNav extends StatelessWidget {
  const _HubBottomNav({required this.careerId});

  final int careerId;

  @override
  Widget build(BuildContext context) {
    void soon() => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Coming soon')));

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const _NavItem(
                icon: Icons.grid_view,
                label: 'Hub',
                active: true,
              ),
              _NavItem(
                icon: Icons.groups,
                label: 'Squad',
                onTap: () => context.go('${Routes.tactics}?careerId=$careerId'),
              ),
              _NavItem(
                icon: Icons.sports_soccer,
                label: 'Matches',
                onTap: () => context.go('${Routes.results}?careerId=$careerId'),
              ),
              _NavItem(icon: Icons.emoji_events, label: 'Trophy', onTap: soon),
              _NavItem(icon: Icons.more_horiz, label: 'More', onTap: soon),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.onSecondaryContainer
        : AppColors.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.xlAll,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.secondaryContainer : Colors.transparent,
          borderRadius: AppRadii.xlAll,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: AppTypography.labelSmall.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
