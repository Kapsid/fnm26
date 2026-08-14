import 'package:flutter/material.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// A development-only showcase of the "Pro Pitch Executive" design system:
/// typography scale and every reusable component. Handy for visual review and
/// as a stable target for widget/golden tests.
class StyleGalleryScreen extends StatefulWidget {
  const StyleGalleryScreen({super.key});

  @override
  State<StyleGalleryScreen> createState() => _StyleGalleryScreenState();
}

class _StyleGalleryScreenState extends State<StyleGalleryScreen> {
  int _selectedRow = 0;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(Routes.home),
        ),
        title: const Text('Style Gallery'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _section('Typography'),
          Text('Display Large', style: text.displayLarge),
          Text('Headline Large', style: text.headlineLarge),
          Text('Headline Medium', style: text.headlineMedium),
          Text('Body large — lead your nation.', style: text.bodyLarge),
          Text('Body medium — squad and tactics.', style: text.bodyMedium),
          const Text('LABEL · MONO 0042', style: AppTypography.labelMedium),

          _section('Buttons'),
          PrimaryButton(
            label: 'New Game',
            icon: Icons.play_arrow_rounded,
            onPressed: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
          const PrimaryButton(
            label: 'Loading',
            onPressed: null,
            isLoading: true,
          ),

          _section('Tactical chips'),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              TacticalChip('GK'),
              TacticalChip('CB'),
              TacticalChip('ST', emphasized: true),
              TacticalChip('RW'),
            ],
          ),

          _section('Card'),
          AppCard(
            child: Row(
              children: [
                const NationBadge(code: 'BRA', size: 48),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Brazil', style: text.titleMedium),
                      Text('South America · #5', style: text.bodySmall),
                    ],
                  ),
                ),
                const TacticalChip('FREE', emphasized: true),
              ],
            ),
          ),

          _section('Data list'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(3, (i) {
                final names = ['Alisson', 'Marquinhos', 'Vinícius Júnior'];
                final pos = ['GK', 'CB', 'LW'];
                return AppListRow(
                  title: names[i],
                  subtitle: 'Overall 8${7 - i}',
                  leading: const NationBadge(code: 'BRA', size: 36),
                  trailing: TacticalChip(pos[i]),
                  selected: _selectedRow == i,
                  showDivider: i != 2,
                  onTap: () => setState(() => _selectedRow = i),
                );
              }),
            ),
          ),

          _section('Text field'),
          const AppTextField(label: 'Manager name', hint: 'e.g. Alex Ferguson'),

          _section('Stat bars'),
          const StatBar(label: 'Pace', value: 88),
          const SizedBox(height: AppSpacing.sm),
          const StatBar(label: 'Passing', value: 72),
          const SizedBox(height: AppSpacing.sm),
          const StatBar(label: 'Tackling', value: 41),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(
      top: AppSpacing.lg,
      bottom: AppSpacing.sm,
    ),
    child: Text(title, style: AppTypography.labelMedium),
  );
}
