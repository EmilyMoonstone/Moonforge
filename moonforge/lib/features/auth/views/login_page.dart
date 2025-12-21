import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/features/auth/widgets/login_form.dart';
import 'package:moonforge/features/auth/widgets/signup_form.dart';
import 'package:moonforge/gen/assets.gen.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/design_constants.dart';
import 'package:moonforge/layout/widgets/app_top_bar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:window_manager/window_manager.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  int index = 0;
  String? prefillEmail;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.background,
      constraints: const BoxConstraints.expand(),
      child: Column(
        children: [
          SizedBox(
            height: kAppBarHeight,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(child: DragToMoveArea(child: SizedBox.expand())),
                const WindowButtons(),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = math.min(constraints.maxWidth, 1200.0);
                final height = math.min(constraints.maxHeight, 800.0);

                return Center(
                  child: Padding(
                    padding: AppSpacing.paddingXxxl,
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: Card(
                        padding: EdgeInsets.zero,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Stack(
                                children: [
                                  SizedBox.expand(
                                    //Clip left top and bottom corners
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      ),
                                      child: ShaderMask(
                                        shaderCallback: (rect) => LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.center,
                                          colors: [
                                            theme.colorScheme.background,
                                            Colors.transparent,
                                          ],
                                        ).createShader(rect),
                                        blendMode: BlendMode.darken,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: Assets.images.forge
                                                  .image()
                                                  .image,
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                Colors.black.withAlpha(45),
                                                BlendMode.darken,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: AppSpacing.paddingXxxl,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Assets
                                            .logo
                                            .moonforgeLogoPurple
                                            .moonforgeLogoPurple256
                                            .image(height: 64),
                                        Spacer(),
                                        Text(
                                          "Forge Your Adventure.",
                                          style: theme.typography.h2,
                                        ),
                                        Text(
                                          "Create. Manage. Play.",
                                          style: theme.typography.h2,
                                        ),
                                        Gap(AppSpacing.md),
                                        Text(
                                          "Join the ultimate platform for crafting and managing your tabletop RPG campaigns with the power of the moon.",
                                        ).muted,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: AppSpacing.paddingXxxl,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Gap(AppSpacing.xxl),
                                    Text(
                                      "Welcome Back",
                                      textAlign: TextAlign.center,
                                    ).h1,
                                    Gap(AppSpacing.md),
                                    Text(
                                      "Enter your credentials to access the realm.",
                                      textAlign: TextAlign.center,
                                    ).muted,
                                    Gap(AppSpacing.xxxl),
                                    Card(
                                      padding: AppSpacing.paddingXs,
                                      child: Row(
                                        spacing: AppSpacing.xs,
                                        children: [
                                          Expanded(
                                            child: Button(
                                              style: index == 0
                                                  ? ButtonStyle.secondary()
                                                  : ButtonStyle.ghost(),
                                              onPressed: () => setState(() {
                                                index = 0;
                                              }),
                                              child: Padding(
                                                padding: AppSpacing.paddingXs,
                                                child: Text("Login"),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Button(
                                              style: index == 1
                                                  ? ButtonStyle.secondary()
                                                  : ButtonStyle.ghost(),
                                              onPressed: () => setState(() {
                                                index = 1;
                                              }),
                                              child: Padding(
                                                padding: AppSpacing.paddingXs,
                                                child: Text("Sign Up"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gap(AppSpacing.xxl),
                                    Expanded(
                                      child: Switcher(
                                        index: index,
                                        direction: AxisDirection.left,
                                        children: [
                                          Expanded(
                                            child: LoginForm(
                                              initialEmail: prefillEmail,
                                            ),
                                          ),
                                          Expanded(
                                            child: SignupForm(
                                              onSignedUp: (email) async {
                                                setState(() {
                                                  prefillEmail = email;
                                                });
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        'Check your email',
                                                      ),
                                                      content: Text(
                                                        'We sent a confirmation email to $email. Click the link in the email to verify your account.',
                                                      ),
                                                      actions: [
                                                        PrimaryButton(
                                                          onPressed: () {
                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            'Got it',
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
