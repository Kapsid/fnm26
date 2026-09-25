import 'package:fnm/domain/services/federation/federation_finance.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Writing the federation's departments and buildings in the manager's own
/// language — the display-edge translator pattern of
/// `competition_label.dart`, applied to [Department].

/// A department's name, as the invest screen lists it.
String departmentLabel(AppLocalizations l, Department d) => switch (d) {
  Department.youth => l.federationDeptYouth,
  Department.commercial => l.federationDeptCommercial,
  Department.medical => l.federationDeptMedical,
  Department.naturalization => l.federationDeptNaturalisation,
  Department.boardRelations => l.federationDeptBoardRelations,
};

/// One line on what investing in a department buys.
String departmentBlurb(AppLocalizations l, Department d) => switch (d) {
  Department.youth => l.federationDeptYouthBlurb,
  Department.commercial => l.federationDeptCommercialBlurb,
  Department.medical => l.federationDeptMedicalBlurb,
  Department.naturalization => l.federationDeptNaturalisationBlurb,
  Department.boardRelations => l.federationDeptBoardRelationsBlurb,
};

/// The building a department is housed in, for the development section.
String departmentBuildingName(AppLocalizations l, Department d) => switch (d) {
  Department.youth => l.federationBuildingAcademy,
  Department.commercial => l.federationBuildingCommercial,
  Department.medical => l.federationBuildingMedical,
  Department.naturalization => l.federationBuildingScouting,
  Department.boardRelations => l.federationBuildingBoardroom,
};
