import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// How a player's form is drawn wherever it appears: the call-up row shows
/// the icon on its own, and the player's page explains it, so both read from
/// here and can never disagree about what a flame means.
({IconData icon, Color color}) formLook(PlayerForm form) => switch (form) {
  PlayerForm.onFire => (
    icon: Icons.local_fire_department,
    color: const Color(0xFFE8622C),
  ),
  PlayerForm.good => (icon: Icons.trending_up, color: AppColors.positive),
  PlayerForm.steady => (
    icon: Icons.remove,
    color: AppColors.onSurfaceVariant,
  ),
  PlayerForm.poor => (
    icon: Icons.trending_down,
    color: const Color(0xFFEFC94C),
  ),
  PlayerForm.cold => (icon: Icons.ac_unit, color: const Color(0xFFD64545)),
};

/// The word for a player's form.
String formLabel(AppLocalizations l, PlayerForm form) => switch (form) {
  PlayerForm.onFire => l.formOnFire,
  PlayerForm.good => l.formGood,
  PlayerForm.steady => l.formSteady,
  PlayerForm.poor => l.formPoor,
  PlayerForm.cold => l.formCold,
};
