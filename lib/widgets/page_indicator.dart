import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helios_test/bloc/user_bloc.dart';
import 'package:helios_test/bloc/user_event.dart';
import 'package:helios_test/bloc/user_state.dart';
import 'package:helios_test/widgets/circle_button.dart';

import '../utils.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(height: 100),
      color: lightBlue,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          final int maxPage = (state.users.length - 1) ~/ usersLimit;
          void onPressed(int page) {
            context.read<UsersBloc>().add(PageChanged(page));
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              state.page > 2 || (state.page == 2 && maxPage > 2)
                  ? CircleButton(
                      onPressed: () => onPressed(0),
                      number: 0,
                      hovered: state.page == 0,
                    )
                  : const SizedBox(
                      width: 48,
                    ),
              Expanded(
                child: Builder(
                  builder: (_) {
                    switch (maxPage) {
                      case 0:
                        return CircleButton(
                          onPressed: () => onPressed(0),
                          number: 0,
                          hovered: state.page == 0,
                        );
                      case 1:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleButton(
                              onPressed: () => onPressed(0),
                              number: 0,
                              hovered: state.page == 0,
                            ),
                            CircleButton(
                              onPressed: () => onPressed(1),
                              number: 1,
                              hovered: state.page == 1,
                            ),
                          ],
                        );
                      default:
                        List<int> numbers = getThree(state.page, maxPage);

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleButton(
                              onPressed: () => onPressed(numbers[0]),
                              number: numbers[0],
                              hovered: numbers[0] == state.page,
                            ),
                            CircleButton(
                              onPressed: () => onPressed(numbers[1]),
                              number: numbers[1],
                              hovered: numbers[1] == state.page,
                            ),
                            CircleButton(
                              onPressed: () => onPressed(numbers[2]),
                              number: numbers[2],
                              hovered: numbers[2] == state.page,
                            )
                          ],
                        );
                    }
                  },
                ),
              ),
              state.page + 1 < maxPage
                  ? CircleButton(
                      onPressed: () => onPressed(maxPage),
                      number: maxPage,
                      hovered: state.page == maxPage,
                    )
                  : FloatingActionButton(
                      backgroundColor: green,
                      mini: true,
                      onPressed: () =>
                          context.read<UsersBloc>().add(UsersFetched()),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
