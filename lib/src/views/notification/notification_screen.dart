import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/simple_bloc_observer.dart';
import 'package:feed_sx/src/views/notification/bloc/notifications_bloc.dart';
import 'package:feed_sx/src/views/notification/widget/notification_tile.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class NotificationScreen extends StatefulWidget {
  static const String route = "/notification_screen";
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Map<String, User>? users = {};
  PagingController<int, NotificationFeedItem> pagingController =
      PagingController<int, NotificationFeedItem>(
    firstPageKey: 1,
  );
  NotificationsBloc? _notificationsBloc;

  int _page = 1;

  @override
  void initState() {
    super.initState();
    Bloc.observer = SimpleBlocObserver();
    _notificationsBloc = NotificationsBloc();
    addPageRequestListener();

    _notificationsBloc!.add(
      const GetNotifications(
        offset: 1,
        pageSize: 20,
      ),
    );
  }

  void addPageRequestListener() {
    pagingController.addPageRequestListener(
      (pageKey) {
        _notificationsBloc!.add(
          GetNotifications(
            offset: pageKey,
            pageSize: 20,
          ),
        );
      },
    );
  }

  void updatePagingControllers(Object? state) {
    if (state is NotificationsLoaded) {
      _page += 1;
      if (state.response.users != null) users?.addAll(state.response.users!);
      if (state.response.items!.length < 20) {
        pagingController.appendLastPage(state.response.items!);
      } else {
        pagingController.appendPage(state.response.items!, _page);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        locator<NavigationService>().goBack();
        return false;
      },
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0,
          leading: BackButton(
            onPressed: () => locator<NavigationService>().goBack(),
            color: kGrey1Color,
          ),
          title: const Text(
            "Notifications",
            style: TextStyle(color: kGrey1Color),
          ),
        ),
        body: BlocConsumer(
          bloc: _notificationsBloc,
          buildWhen: (previous, current) {
            if (current is NotificationsPaginationLoading &&
                (previous is NotificationsLoading ||
                    previous is NotificationsLoaded)) {
              return false;
            }
            return true;
          },
          listener: (context, state) => updatePagingControllers(state),
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(
                child: Loader(),
              );
            } else if (state is NotificationsError) {
              return getNotificationsErrorView(state.message);
            } else if (state is NotificationsLoaded) {
              return getNotificationsLoadedView(state: state);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget getNotificationsLoadedView({
    NotificationsLoaded? state,
  }) {
    return Column(
      children: [
        Expanded(
          child: PagedListView<int, dynamic>(
            padding: EdgeInsets.zero,
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
              noMoreItemsIndicatorBuilder: (context) => const SizedBox(
                height: 20,
              ),
              noItemsFoundIndicatorBuilder: (context) => const Scaffold(
                backgroundColor: kWhiteColor,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "No notifications to show",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
              itemBuilder: (context, item, index) =>
                  NotificationTile(response: item, users: users!),
            ),
          ),
        ),
      ],
    );
  }

  Widget getNotificationsErrorView(String message) {
    return Center(
      child: Text(message),
    );
  }
}
