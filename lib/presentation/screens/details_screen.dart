import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/domain/entities/push_message.dart';
import 'package:push_app/presentation/blocs/notifications/notifications_bloc.dart';

class DetailsScreen extends StatelessWidget {

  final String pushMessageId;

  const DetailsScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {
    final PushMessage? message = context.watch<NotificationsBloc>().getMessageById(pushMessageId);
    if (kDebugMode) print('>> [details_screen.dart] message: $message');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles push message'),
      ),
      body: (message != null) ? _DetailsView(message: message) : const Center(child: Text('Notificación no existe')),
    );
  }
}

class _DetailsView extends StatelessWidget {

  final PushMessage message;
  const _DetailsView({required this.message});

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          (message.imageUrl != null) ? Image.network(message.imageUrl!) : const Icon(Icons.notifications),
          const SizedBox(height: 30),
          Text(message.title, style: textStyles.titleMedium),
          Text(message.body, style: textStyles.bodyMedium),
          const Divider(),
          Text(message.data.toString()),
        ],
      ),
    );
  }

}