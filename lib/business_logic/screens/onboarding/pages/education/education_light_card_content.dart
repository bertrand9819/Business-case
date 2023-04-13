import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../widgets/icon_container.dart';

class EducationLightCardContent extends StatelessWidget {
  const EducationLightCardContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const <Widget>[
        IconContainer(
          icon: Icons.map,
          padding: kPaddingS,
        ),
        IconContainer(
          icon: Icons.app_registration,
          padding: kPaddingM,
        ),
        IconContainer(
          icon: Icons.straighten,
          padding: kPaddingS,
        ),
      ],
    );
  }
}
