import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/domain/entities/push_message.dart';
import 'package:push_app/firebase_options.dart';
part 'notifications_event.dart';
part 'notifications_state.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) print(">> Handling a background message: ${message.messageId}");
}


class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {

    on<NotificationStatusChanged>(_notificationStatusChanged);

    on<NotificationReceived>(_onPushMessageReceived);

    _initialStatusCheck();// Verificacion de estado de notificaciones
    _onForegroundMessage();// Listener para notificaciones en foreground=primer plano
  }

  /// - [FCM] = Firebase + cloud + Messaging
  /// - Asegura la existencia de la configuracion de Firebase
  static Future<void> initializeFCM() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationStatusChanged(NotificationStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(
      status: event.status
    ));
    _getFCMToken();
  }

  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(
      notifications: [
        event.pushMessage, // el nuevo pushMessage siempre sera el primero en el listado
        ...state.notifications
      ]
    ));
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  /// - [FCM]: Firebase + cluod + messaging
  void _getFCMToken() async {
    // final settings = await messaging.getNotificationSettings();
    // if(settings.authorizationStatus != AuthorizationStatus.authorized) return;
    if (state.status != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    if (kDebugMode) print('>> token: $token');
  }

  void handleRemoteMessage(RemoteMessage message) {
    // if (kDebugMode) print('>> message.data: ${message.data}');
    if (message.notification == null) return;

    final notification = PushMessage(
      messageId: message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: (Platform.isAndroid)
        ? message.notification!.android?.imageUrl
        : message.notification!.apple?.imageUrl,
    );

    if (kDebugMode) print('>> notification: $notification');// app en background

    add(NotificationReceived(notification));

  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  PushMessage? getMessageById(String pushMessageId) {
    final exist = state.notifications.any((element) => element.messageId == pushMessageId);
    if(!exist) return null;

    return state.notifications.firstWhere((element) => element.messageId == pushMessageId);
  }

}
